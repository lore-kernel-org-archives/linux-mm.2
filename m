Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6808BC54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 15:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00F046B0088; Fri, 31 Jul 2026 11:17:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F02146B008A; Fri, 31 Jul 2026 11:17:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF1706B0093; Fri, 31 Jul 2026 11:17:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 995736B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 11:17:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1471B14046F
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:17:33 +0000 (UTC)
X-FDA: 85049425986.03.9A316D3
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id EF1D31C0010
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:17:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=r9uQ+uHo;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785511051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QOdikcJRo1h3a9sD/t/2mX2tsaLsS7uHoOpBXELRAPI=;
	b=vjOUlmdi6ONyjQqkRTsBEzEB53u/wrSvcGurfRaUShmVlPJz4npnNxr39+gN5Z8cZFI9vU
	AC2/gMSVbzdi+jX5K7WGMzGigOYotdpG85M9/4qhN1Cy6chbgIfl7RSqCzPtW7KvKFZ73n
	xQJukymXa4U5Su/J0Xl1mAXacGpokWo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785511051;
	b=PhSWILxCMDvKDipOVYO8cMRqaReg5JElkFxhCIjjDA5qv/GNBtS++ClFqtlPRTrlUoyE6q
	Xaa0Qt74rkrsi0caZMA9/zHr4eM4KdOSMYHYCpa7hXBm/pqfABxj3BIFe4exfkL37O2J9N
	YToBHyFH2q6wqEm73/YVNpaJpiKElhw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=r9uQ+uHo;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e53581361so58954585a.1
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785511050; x=1786115850; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QOdikcJRo1h3a9sD/t/2mX2tsaLsS7uHoOpBXELRAPI=;
        b=r9uQ+uHocNbVxpodc3pzPqTekJfAH2z+CH4WTm+/lUkGPZN8yHnnJ29eU9WJctY3Wd
         pReKheF01GYOMD4Zo77dL+bYQ9vhktEAw+Fl8MbKC7S87n8hZrJuMGkFHomdSsWHSgyS
         Bw396mCDi/bhRY78mIOZUi9TohNnTnS+8AMmMRvrGeBK10/hLGJfmnUnxQjOz7U40s3P
         Fja5fxm3TBXxt+2n71yf7vFNrXN7fDsvG7Z66iuf9hWjoBLb1fY81OuGPhWrZoSyP4J9
         8kcDdkfgTi6MbIIgBLW8hxmL/o+ki2V+zo/+pOElH1WlXybWYPp+rXX7SRtrqck8x30K
         bc1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785511050; x=1786115850;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QOdikcJRo1h3a9sD/t/2mX2tsaLsS7uHoOpBXELRAPI=;
        b=NCt7J15udrBuVbpEFbGY3kGgdtN73NdbqFWYqgzRuf3XuVHSAYosJ5O1fiL/618qBO
         tz8O2pTv0NiSnKrzjrHWgg9s9AQfmbSN6cd/xswc1SHlpqkKE3JdZKhVJ7qmOZFDLge8
         qX50GJj1w3TKspJeIuOyVwQGwU1R9Tyqc+nK/FcNjEYZPkoV7V5S8rts7Ig/kWQyAXLG
         B1SHwNmicCpx87ePbmvIK3WTGhvGy31bb3wUohMZb3Iim8rI0802rPZDrGM0MJbgrmEt
         zhF9+I1CQBId9lv9fN9ctqxAbjCUHR/PsGwp6kPIQtBtNjPGSbk9kULKPTxXJsiIW+rB
         +fmA==
X-Forwarded-Encrypted: i=1; AHgh+Rp7qywmaSu5tiwfUTiF0QxQSo/f2nMFo5edy1eA18Ll86Lz2oCUj5VHw+CO+NZi/r2ok5uGYJsoUQ==@kvack.org
X-Gm-Message-State: AOJu0YzG/zE2J6Uz93s/jLvJJrm9lwRlHn2DfOOBS3KKcKU04N1AeT0u
	ZY2wJOzbbjliH3rZv2YMOL2bMQLTJYs0QptoZusbcN0yBNgRq2UlTY4t2TMVfgdLO9A=
X-Gm-Gg: AR+sD12fLz7KwyyfGEKf9DmjdWCdqhij+COgZwKWDhd99JZlPh975Ie6V2Cp8cr2Okd
	WweqhTo3185U+G521OhT89v2AyfoQNRNS0Tx/gBlLNL625Wfk9irAipp2m7wwxlYncfOck3QtZb
	MbMXCJBWWoLZLQGMUp1WD65eNdJiEQlIcFIbHdrFhSohQJ1JJPgR8KpqIQ4lY9+aDAJi5gUgS4D
	lkhlqdANQFmAW7Gj66zC/mKeIqtygTANmzVz2Z9L8NePIfOFby6hFywc3308/ZgjElNsN8BG/EZ
	Jr4Swlq/NRI7OhJ7Iek8LFU/S6MoS86O/FppuFmoqIjTCn2Pb2Dkol4c64F4tjq30OH8zh6DRGL
	CWtLLnKrw4Ev8mF/fKyIZVPbNfxd8VULGi8QSrhFdyPAH5nfXa/33fIlvoC2r2ym3BXOb6Py/1z
	2NDyZ7J9yhh6XnxcH9gDrlmvKGfJYVOiGPFrFWUQtuqlJyMcB9B9O44RtMIAo=
X-Received: by 2002:a05:620a:1003:b0:92e:9cc7:fa46 with SMTP id af79cd13be357-934a08b94e9mr67580585a.21.1785511045509;
        Fri, 31 Jul 2026 08:17:25 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9349c199e03sm73739985a.30.2026.07.31.08.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:17:23 -0700 (PDT)
Date: Fri, 31 Jul 2026 11:17:20 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev,
	jiahao1@lixiang.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org,
	mkoutny@suse.com, muchun.song@linux.dev, nphamcs@gmail.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	stable@vger.kernel.org, tj@kernel.org, yosry@kernel.org
Subject: Re: [PATCH v3 2/2] mm/zswap: Support batch writeback in
 shrink_memcg()
Message-ID: <amy8gAN33W4QsM5R@cmpxchg.org>
References: <amufiuAaZbuDdKkQ@cmpxchg.org>
 <20260731071900.38942-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731071900.38942-1-jiahao.kernel@gmail.com>
X-Rspamd-Queue-Id: EF1D31C0010
X-Stat-Signature: 78qtn5jqpzo81uo8p9zuucawk8dza31r
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785511050-627755
X-HE-Meta: U2FsdGVkX19Y0v4LrwsMeH57Kgclmsu9AbLigUWqEs8kOSuQmPZKBHsmXoDkEoFFgjXq7tlZ+LjLsND/EsLpzj/yS1+3C8opqp2RveWrIujnJBLLiofwAqy2OmnKJsfdI2lvzUy6npARX4n7NgnYyOhjC/oSZZ0C7/hu5v6nYXeU7Rzl72+hchynppgLJq1Iiya79H9wIe2hBM3E6qyXmW8A6hXgr2HPDdqb+wwEXs51+Lvi3JOas0tuhpvqL04BKMGRBhusguDWiy24e4MRyjJ3BPT6RkWfkkYapv7S8DREWQWVx2FYyZiLcdjKcCRapWaAolANgPCp1EAb95V7MG5kQq+oDf8mwi2ow6dg1WuuxznL/5/hX7fWgFVYYVMNzwZHkOr5GEgT5HaX28eazgzGK3I8jLWWaDMJjiEHthAfSWmb/yHdnM53yXebTqR88mvKiatqLLbC1T58eFuodDQtz0OuxDIzE26ee9mmSbFi/1x8+VSQ8KK+a61STy1Ca6ZSpdilc7Qx8EC91WVzTzmAkeK1lZLp9hRkat95c3QmV++RS3r4XWqVWcr7EMTZOT0cgNrH56jpPV/2S43PAf1es+6rQnrjnIwBmdkX9cuzOjIiVQ9K2uK0f3WtAO/kc2a4lzMqv6c+dM+MSGeaVgD4W/oiA/ygY3l54Q0MsQmYkzJGu4Sj+6rodRQcNayvdigFKYoidhHk0AEzmqY63+YF2LCUT5XNDGvJaI7snrgxreit7CEV8ykQ90dpPVRymUc3oyVxvUQ1Fnlvl9b5TuP9sKOU9wtGFjXdlWpxAGd2N6OI/iFa6xcTy4N3hS0yWXGETaNoP3BR6KEIsltmyh9ToOYwJ5ZRaN6Rhi33iQnScVOceHte3ZY7VZuMTd893y7VXQCyhvuPmXWj8o96/dP25BBuimvbH1yKj/56lIwEep+jmdSFfcO+gSBBwAVXvTnbCq+r4nk7PDpTKva
 oChpS9e3
 //pRp8VTOhN9CuaW3qX6hCOzEScUER9xL1z8+FXrQGp9IwGT8EmWV6QWPTNiJekA6x5ZWA5naoutF7Zk0bPXF82gFjE3cw2fSraQF3M+F3t99BoPpxBsZBZPA6Lo582z/a590i8VpexiL74Nrr4yPb5gg+ecZ3gUVS0SSzJAWCGWCerfGjUrbL0JnCaTX6c+OGCJwYJKOfY5U+wrd037DUoI2Lz6DS03v3GrjA9NYmiWVV859Ia/xhI82moe6qm33+80+kMl+uN24Jhsv4fVljqS3JOr3WFrXDxzMaK323tPPk3QTPKCg5FL1h40iRzldd7zjDxb9uWN3ktBwS7jphiN+lGa/a8/YN+bcFnyys8B+WjrziD+LaqiyLDyyPiSzXtW0bnNmLQiegr4jJBJECn9xtLe7oMWoOvDNW8wMhNj6OvCsH28DdmfpKJS07IC49zKqhdHp4LBpm1ZrzttbZ+Dng3US1HgGO+xlXBuTrAiIBLH5ZSx/LZ36na5Zxf4YHYegSy2yiHQwwH6vW4g6SeLdzIYoHNL0AP6hhLtK3LR2bRWcFaSFin2d+Xyo6REnIZiDQUEPITMtjt8BTnkoKtJoQzNbMDKqYrSjgruXoL510JPP6h82kYzid0lqSb5LZB+t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 03:19:00PM +0800, Hao Jia wrote:
> From: Hao Jia <jiahao1@lixiang.com>
> 
> Currently, shrink_memcg() writes back at most one entry per-node during
> its traversal. This makes shrink_worker() inefficient, as it must
> repeatedly re-enter shrink_memcg() to make any substantial progress.
> Under high memory pressure, this can cause the writeback speed to be
> too slow to keep up with refaults, leading to zswap store failures and
> forcing pages to skip zswap and go directly to disk, which results in
> an LRU inversion.
> 
> To address this, extend shrink_memcg() and rewrite its LRU iteration logic,
> enabling batch writeback for both the shrink_worker() and zswap_store() paths.
> To prevent shrink unfairness across NUMA nodes caused by a shared global scan
> quota, limit scanning to up to SWAP_CLUSTER_MAX pages per node and write back
> any reclaimable entries found.
> 
> Test Setup:
> - Total memory: 32 GB, 1 NUMA node.
> - zswap settings: accept_threshold_percent=50, shrinker_enabled=N.
> 
> Test Case 1:
> Set max_pool_percent=1, allocate 512MB of anonymous pages, and fill them
> with random data (to avoid compression). Then, use cgroup memory.reclaim
> to force a large amount of anonymous pages into zswap. At an interval of
> 2ms, allocate a 4K anonymous page where the first 4 bytes are random numbers
> and the rest are zeros, and then trigger reclamation of this 4K page through
> cgroup memory.reclaim. When the pool threshold is reached, shrink_memcg()
> will be triggered.
> The test data after running for 120s is as follows:
>                                 Baseline      Patched
> shrink_worker wakeups              5,363          169
> shrink_memcg calls            11,373,201      350,703
> written_back pages                40,212       40,241
> zswap_store calls                161,190      163,753
>    store succeeded (ret=1)       102,743      117,183
>    store rejected (ret=0)         58,447       46,570
>    store reject rate                ~36%        ~28%
> pool_limit_hit delta              55,826       33,760
> pswpout                           98,659       86,811
> pswpin                                 2            0
> 
> Test Case 2:
> We evaluated the following two sub-configurations using stress-ng inside
> a cgroup capped at memory.max=1G for 120 seconds:
>   Test Case 2a (max_pool_percent=1): Continuously triggers the global
>   zswap pool limit, thereby waking up shrink_worker() to perform asynchronous
>   shrinking.
>   Test Case 2b (zswap.max=320M, max_pool_percent=50): Continuously triggers
>   the cgroup's zswap.max limit, thereby invoking synchronous shrinking.
> Command executed for both setups:
>    bash -c 'echo $$ > /sys/fs/cgroup/zswaptest/cgroup.procs ; \
>    exec stress-ng --vm 4 --vm-bytes 4G --vm-keep --vm-method rand-set -t \
> 120s -q'
> 
> Test Case 2a (max_pool_percent=1):
>                                 Baseline       Patched
> shrink_worker wakeups              5,640         1,308
> shrink_memcg calls             8,481,500     3,140,972
> written_back pages                   260       468,216
> zswap_store calls              2,742,756     2,011,269
>    store succeeded (ret=1)       934,640       947,988
>    store rejected (ret=0)      1,808,116     1,063,281
>    store reject rate                ~66%          ~52%
> pool_limit_hit delta           1,181,310       196,882
> pswpout                        1,808,376     1,531,497
> pswpin                         4,288,497     3,635,365
> Test Case 2b (zswap.max=320M, max_pool_percent=50):
>                                 Baseline       Patched
> shrink_worker wakeups                 0              0
> shrink_memcg calls              687,608         54,002
> written_back pages              639,176        846,663
> zswap_store calls             1,224,222      1,228,548
>    store succeeded (ret=1)      992,816      1,208,123
>    store rejected (ret=0)       231,431         20,425
>    store reject rate               ~19%            ~2%
> pool_limit_hit delta                  0              0
> pswpout                         870,745        867,360
> pswpin                        1,707,823      1,216,814
> 
> Under identical workloads and runtimes, batched zswap shrinking
> exhibits a significant reduction in both shrink_worker() wakeups
> and shrink_memcg() calls. Furthermore, the sharp drop in both pswpin
> and zswap_store() rejections demonstrates that batching zswap shrink
> operations effectively mitigates zswap_store() failures caused by
> hitting the pool limit. This significantly prevents pages from bypassing
> zswap and falling back directly to disk, thereby reducing LRU inversion.
> 
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Acked-by: Yosry Ahmed <yosry@kernel.org>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Hao Jia <jiahao1@lixiang.com>
> ---
>  mm/zswap.c | 30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 48fc7b575e24..d406c14925d8 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1275,6 +1275,21 @@ static struct shrinker *zswap_alloc_shrinker(void)
>  	return shrinker;
>  }
>  
> +/*
> + * Scan up to SWAP_CLUSTER_MAX pages on each per-node zswap LRU of @memcg
> + * and write back the reclaimable ones.
> + *
> + * Since the second-chance algorithm rotates referenced entries to the
> + * LRU tail, the per-node scan is capped at the current LRU length so
> + * each entry is scanned at most once per call. It is up to the caller
> + * to handle retries, deciding whether to scan another memcg to complete
> + * the full iteration, or to rescan the current memcg to drain its zswap
> + * entries.
> + *
> + * Return: 0 if at least one entry was written back, -EAGAIN if entries
> + * were scanned but none could be written back, or -ENOENT if @memcg has
> + * writeback disabled, is a zombie cgroup, or has empty zswap LRUs.
> + */
>  static int shrink_memcg(struct mem_cgroup *memcg)
>  {
>  	int nid, shrunk = 0, scanned = 0;
> @@ -1290,13 +1305,24 @@ static int shrink_memcg(struct mem_cgroup *memcg)
>  		return -ENOENT;
>  
>  	for_each_node_state(nid, N_NORMAL_MEMORY) {
> -		unsigned long nr_to_walk = 1;
> +		unsigned long nr_to_walk, node_budget;
> +
> +		/*
> +		 * Cap the scan at the per-node LRU length so each entry is
> +		 * scanned at most once per call.
> +		 */
> +		node_budget = min(SWAP_CLUSTER_MAX,
> +			     list_lru_count_one(&zswap_list_lru, nid, memcg));

AFAICS you can just do unsigned long nr_to_walk = SWAP_CLUSTER_MAX.

__list_lru_walk_one() does a list_for_each_safe() that will exit the
same way whether you hit !nr_to_walk or run out of items.

> +		if (!node_budget)
> +			continue;
>  
> +		nr_to_walk = node_budget;
>  		shrunk += list_lru_walk_one(&zswap_list_lru, nid, memcg,
>  					    &shrink_memcg_cb, NULL, &nr_to_walk);
> -		scanned += 1 - nr_to_walk;
> +		scanned += node_budget - nr_to_walk;

scanned += SWAP_CLUSTER_MAX - nr_to_walk;

