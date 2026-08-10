Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77F79C5AE49
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 825DF6B007B; Mon, 10 Aug 2026 10:25:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FCEE6B008A; Mon, 10 Aug 2026 10:25:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739996B008C; Mon, 10 Aug 2026 10:25:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BE9F6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:25:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D4E551601AB
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:25:29 +0000 (UTC)
X-FDA: 85085582778.27.8D1CD9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1924C20002
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:25:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=czr6gQOo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786371928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LtnIEsXkdLqMumJh+t7+SeTxxe5v1I7wD0inqEiePn4=;
	b=AV7pq/9/KxpXfjAmu5x7yY0isIPjGUTjO+CB69mZpS2MqM4SZ5dUobiAb9ZK9Ko/7P9AKT
	5fvslfcp9iGR1spoIu4lc81MaPup8v4/sfd9m6lG6PRZzj5+T0YD6NYbB8fOjh3B1hhuIM
	JJuSocTiywV8M5+K5sa/pUgQDB/1vXM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=czr6gQOo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786371928;
	b=AY5LiyhLh4MxRTpgy2sTwCViYboXNF4zq7QGkkxtU4Qh5La+6jjbuONZLXYqZzmjat2jHT
	H8ffIw9joW5pgSbJQ+IN3+9a2Zi7CXh43S42wH+LVQ3NDob232k1XwwtnzS4LGUOk732R5
	70XsT4/iLqCdzdoXwTxSEr1HN1u+WJ4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8656C60120;
	Mon, 10 Aug 2026 14:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BFA1F000E9;
	Mon, 10 Aug 2026 14:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786371927;
	bh=LtnIEsXkdLqMumJh+t7+SeTxxe5v1I7wD0inqEiePn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=czr6gQOo2m1T62FYG6zZh7dFXaUugKlMXCFpjmRWQMChroD/a9q/W22SIJuQfLHwA
	 edTywak2BJd0UooAeDOHu5wTblZnzZ/ToAdqBjibVIVqhSiKE0AAPOTvsX+C5+IqPd
	 fR5YjCborg5RhdlN1uZaJ7ICsMtdPeup/CooyFIK/OKPYacBzPiHvggFhcnQdiMhbq
	 rRk6h7npA+KVen2zWVn7Mgb39KD7lzp9NI3c8aRw6CzAMyDiyiBrvyPjHL57ptD+Ox
	 rYqokn5x4pN7XmtbwPnFEYvqUZRiBIEY/LbSLzII6SwZrOnZXeSldNclV1H4UUJp3L
	 Q+4smYNOoweXg==
From: SJ Park <sj@kernel.org>
To: Bharata B Rao <bharata@amd.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com,
	dave.hansen@intel.com,
	gourry@gourry.net,
	mgorman@techsingularity.net,
	mingo@redhat.com,
	peterz@infradead.org,
	raghavendra.kt@amd.com,
	riel@surriel.com,
	rientjes@google.com,
	weixugc@google.com,
	willy@infradead.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	dave@stgolabs.net,
	nifan.cxl@gmail.com,
	xuezhengchu@huawei.com,
	yiannis@zptcorp.com,
	david@kernel.org,
	byungchul@sk.com,
	kinseyho@google.com,
	joshua.hahnjy@gmail.com,
	yuanchu@google.com,
	balbirs@nvidia.com,
	alok.rathore@samsung.com,
	shivankg@amd.com,
	donettom@linux.ibm.com
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
Date: Mon, 10 Aug 2026 07:25:16 -0700
Message-ID: <20260810142518.92987-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <a2fd8c7d-d6d7-4c79-8b4d-3860c04a586f@amd.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1924C20002
X-Stat-Signature: g55iff8xcnpm1ygicokc8g6sfawp4tpe
X-Rspam-User: 
X-HE-Tag: 1786371927-313757
X-HE-Meta: U2FsdGVkX19SdgpYBr75h2oRgeG5GHfwBxz3NxytUNdGBWdr6z9YEQxgPpp4mEvIoswGx555w6L3PeYk0Fxs+K3Kj49yC0nD/vbuWmlqveV7N8XjFzpPQ2BBmFDZWIWQ6Hk1yMTFfCLLUP68umBAwSiR73hBV9jglAO/Aded3d5dLBIzVAohRFn9n9BWhNfmxEWe9lNMzETaiLcVA/Bjq0NHf7I5rN07oFPma0HL2qjmztSV8huc2DOU1d89pRxJrxM9k/IupsRjmEqzQdzTXCjN1ljifzWGhdft7wkacRQ68AU5mKyFR3i5RXQT2qs/zdhPzHSO0ifBDesYGbfaiaBm4eE5NL1RUP2n1ppLDJMeFl8aDkiZRCU053eICX39K28gqnPSaZW77mcMV6xFvry49mnp6biwRkyFCVFuOmMlaB2uj13q9R5o/vb/+5WlIkbLav0AIkQej33EoOS7S25Y+RpwjWnybdtoillgjZPfs1xa5/p4aCOwsDCBubG/i6911IaQWHF2z2s7kSZWtVSb4rdm6OHnt2TmEQjBsnDNJgXzqcS9aaf+0OioL4tJhe2pM7IfRuyROTJ/JksXXg0NR4UM91ZAvAwYF7QLKS67XTWsnqy5Bro32257Hir2ZHqcSVGOTpx64bbALUK97GaAjbZQi3/GNhze2Jj++2ryrSgasBaqtwr6cnE7mzZa3EGw/spZW1J/xGR3f7b0N70jsbLvdPL3yXpfi/Y0WO/D3u21z4ByMRFW+pvJy8qffMnQ/bkSmzlFp4IImShg/yPsxDvMjjYSHfXKC6awjzBwsanjQ76f4rRoAzYA5tZYD5imKTqu2Tv6jamX8vHJ8UWaDc8VqZydzrfLpevG72RM9VdttmjAW+AFKxFYxkIhrEzXLx7eihnPgTySwxjWYcdveqDq/76CPUymY4X+1PucXSKx5h2OyeBRIDNMacgj6FHYLJQRUGxVtcEOPH7
 1Y2lWxsc
 wel+r3Hza47VKZ9cTLi+kutuNmyyquqQi08UuoQDIVHbneCA9FdB0Dvexs4WaozzDzhInrxSjdrJ3USVyRxVVidvVTcIvScDcawXruFOPNZYsthhjriYVBlsBQW/4oo2gTeOHZmygq19p1mf5SDwObRlbvdvApipa3omewpWvHEpgDMMQv3e7aSYaj/Vm8hdT99mpKqP2fs83PJ72krjEkO/kxl3B1tZkLWIyXqABe1LSutc0J6C4s7MCacLXIFT46h9V6I0SnrexMhCgwhCtrd0PbfAo6Ne5IWDOnHSZPL1nO4kEUDRXpDkag3rhECF4Cm4iYhGRROykNgYGZmY+xwEM8Nysr+kMILLC9Y7jdmeiWYtM/a46g8mtSAYhE3PabD9X2MqzTZ0yYaQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Aug 2026 10:16:37 +0530 Bharata B Rao <bharata@amd.com> wrote:

> On 06-Aug-26 7:14 PM, SJ Park wrote:
> > On Thu, 6 Aug 2026 11:19:22 +0530 Bharata B Rao <bharata@amd.com> wrote:
> > 
> >> On 28-Jul-26 11:44 PM, Andrew Morton wrote:
> >>> On Tue, 28 Jul 2026 11:13:48 +0530 Bharata B Rao <bharata@amd.com> wrote:
> >>>
> >>>> This patchset introduces pghot, a subsystem for hot page tracking and
> >>>> promotion.
> >>>
> >>> Can DAMON be used to do this sort of thing adequately?
> >>
> >> Hi SJ,
> >>
> >> I started comparing hot page detection and promotion aspects of DAMON
> >> and pghot through benchmark runs. Here is the first set of results from
> >> pointer chase workload.
> >>
> >> Since I wasn't very familiar with DAMON tunables and settings, I let the
> >> AI to chose some default followed by other combinations. The test harness
> >> is developed and run by AI. Request you to go through this and let me know
> >> you feedback about the combinations and configurations tried here. Based on
> >> that I can adapt the settings for the future runs.
> > 
> > This sounds like you asked AI to do the comparison because you don't know
> > DAMON.  And you still don't know DAMON, so you cannot really explain the
> > results.  So asking me to review what your AI did and guide your AI.  Sigh.
> > 
> > Correct me if I'm wrong.  If I'm not wrong, no, I'm not an AI slop reviewer.  I
> > will not review that until this is clarified.  I call it AI slop regardless of
> > the output when it is something that generated and shared without full
> > understanding from the human user.
> > 
> > If you want me to review something, please send me what you really understand.
> > To compare/discuss DAMON, please learn it first.  Spend time and ask question.
> > I will be more than happy to help that.
> 
> I was seeking feedback about the combinations and configurations that
> were tried so that I can adapt the setting for future runs. I spent time
> looking at the rich set of configuration possibilities [1] that DAMON
> provides and experimented with something very basic to start with, followed
> by a few changes in each step. Now I can see more meaningful numbers
> from DAMON without the need to enable migrate_cold.
> 
> Metric notes
> ------------
> - lat  : steady access latency, ns/access, mean of last 25% of samples
>          (lower is better).  Baselines: base 337 ns, pghot 348 ns
>          (within 3%, so absolute latency is broadly comparable here).
> - node0: end-of-run per-process placement on node 0 (numastat -p).
> - CPU  : cumulative cputime of the monitor/promoter thread over the
>          240 s run, and its peak instantaneous %cpu (ps).  This is the
>          concentrated cost only; see caveat 2 on pghot's distributed
>          cost.
> - promoted: bytes actually migrated (DAMON scheme sz_applied; pghot
>          pgpromote_success).
> 
> 
> DAMON configuration method (default vs manually set)
> ----------------------------------------------------
> The aim was to start from DAMON's own sysfs defaults and set only what
> a promote scheme needs, then change one thing at a time.
> 
> Left at the DAMON default in every run below:
>     sample=5ms, aggr=100ms, update=60s, apply_interval=0 (=aggr),
>     intervals_goal off, watermarks none, quota goals none, filters
>     none.  min_nr_regions=10 (except the page-size runs).
> 
> Set manually in every run (the minimum for migrate_hot to act):
>     operations=paddr; one target region = node 2 physical range;
>     action=migrate_hot; target_nid=0; access pattern nr_accesses>=1
>     (sz>=1 page, any age), i.e. "promote anything accessed at least
>     once in the aggregation window".
> 
> Per-run additions (the single variable that changes each row):
>     D0 default    : nothing extra (pure default + migrate_hot).
>     D1 page-size  : min=max nr_regions = 67,108,864 (one region per
>                     4 KiB page over the 256 GiB target).
>     D2 +quota     : quota bytes=128 MiB, reset=1000 ms (~128 MB/s),
>                     weights sz/acc/age = 0/1000/0 (hottest first).
>     D3 fine+quota : max_nr_regions=100,000 (min default 10) + D2 quota.
>     D4 pagesz+q   : page-size regions (as D1) + a quota (1 GiB/1000 ms)
>                     + the same weights.
> 
> Table 1.  DAMON, base kernel (each row changes one variable)
> ------------------------------------------------------------
> id  config             regions       quota   lat   node0  over   kdamond
>                         (settled/pin) (MB/s)  (ns)  (GB)          CPU
> --  -----------------  -------------  ------  ----  -----  -----  ---------
> B0  baseline           - (no DAMON)   none    337   0.0    -      -
> D0  default (coarse)   11             none    121   64.0  +300%  25s/10%
> D1  page-size          64M pin        none    129   33.0  +106%  277s/100%
> D2  default + quota    14             128     105   23.3   +46%  9s/3.7%
> D3  fine + quota       14-38          128      88   23.6   +47%  14s/5.6%
> D4  page-size + quota  64M pin        ~1000   296    1.0   -94%  270s/100%
> 
> B0 is the no-promotion control on the base kernel (numa_balancing=0,
> no DAMON), and is the reference for the lat column.
> 
> The "over" column is measured against the 16 GiB HOT SET, not against
> B0: over = (node0 - 16 GiB) / 16 GiB.  B0 promotes nothing, so its
> node0 is 0.0 and its over is n/a.
> 
> Regions column:
> - A plain number (D0/D2/D3) is the SETTLED count DAMON adapted to,
>   measured via the damon_aggregated tracepoint.  These rows leave
>   min_nr_regions at the default 10; D3 only raises the max_nr_regions
>   ceiling to 100,000 (a cap, not a target), so DAMON splits/merges
>   freely and settles at 14-38.
> - "64M pin" (D1/D4) means min_nr_regions = max_nr_regions = 67,108,864
>   (one 4 KiB region per page of the 256 GiB target).  Setting min=max
>   PINS the count: DAMON cannot merge/split, so it is forced, not
>   settled.  The actual count was unmeasurable (NA) because the pegged
>   kdamond never completed an aggregation pass to emit the tracepoint.
> 
> Table 2.  pghot, pghot kernel
> -----------------------------
> id  config            thr  lat  node0  over  promoted  kmigrated
>                            (ns) (GB)         (GiB)     CPU
> --  ----------------  ---  ---  -----  ----  --------  ---------
> P0  baseline          -    348   0.0    -      -       0s
> P2  hint-fault (def)  2    124  16.0    0%   16.0      6s/0.7%
> P1  hint-fault        1    112  16.0    0%   15.9      13s/1.1%
> 
> Notes on Table 2:
> - numa_balancing=2, and pghot tunables with the default values
>  (pghot_enabled_sources=1 (hint-fault source), pghot_target_nid=0
>   and pghot_promote_rate_limit_MBps)
> - Both thresholds place exactly the 16 GiB hot set (0% over):
>     P2 pgpromote_success 4,194,304 = 16.0 GiB exactly;
>     P1 pgpromote_success 4,157,158 (15.9 GiB);
> - thr=1 converges faster (first interval already 136 ns; it promotes
>   during the load phase) and is slightly quicker (112 vs 124 ns) at
>   marginally higher kmigrated CPU.  thr=2 starts at 395 ns and
>   converges over the run.
> 
> Caveats
> -------
> 1. Two kernels: DAMON on base, pghot on pghot.  The baselines are
>    within 3% (337 vs 348 ns), so absolute latency is broadly
>    comparable, but this is not a single-kernel A/B.
> 2. The CPU columns are the concentrated monitor/promoter thread only.
>    pghot's hint-fault source also imposes distributed overhead on the
>    application threads (NUMA scanning + hint-fault handling:
>    numa_pte_updates 10-15M, numa_hint_faults 3-8M), which is NOT in the
>    kmigrated figure.  DAMON's cost is concentrated in kdamond and is
>    captured.  A fair total-cost comparison must add pghot's NUMA-
>    balancing tax.
> 3. Latency does not track placement linearly for this workload and the
>    mechanism was not isolated; placement/over-promotion is the primary
>    accuracy metric.
> 4. DAMON and pghot increment different counters (scheme sz_applied vs
>    pgpromote_success); cross-mechanism promotion counts are not
>    directly comparable, so placement (numastat) is used.

Very nice data, thank you for sharing!

A few things would better to be clarified in my humble opinion.

What are the intentions and expectations behind the different configurations?
What is the conclusion you get from the test results?  Depending on this, the
test workload and machine setup would also have rooms to better be clarified.

Also it is not very clear if you still asking my feedback or not.  If you still
want my feedback, could you pleae andd the clarifications to questions I added
above?  That would be helpful for providing more meaningful feedback for you.

> 
> [1] DAMON config directory - tree view
> --------------------------------------
> root@host:/sys/kernel/mm/damon/admin# tree
> .
> └── kdamonds
>     ├── 0
>     │   ├── contexts
>     │   │   ├── 0
>     │   │   │   ├── addr_unit
>     │   │   │   ├── avail_operations
>     │   │   │   ├── monitoring_attrs
>     │   │   │   │   ├── intervals
>     │   │   │   │   │   ├── aggr_us
>     │   │   │   │   │   ├── intervals_goal
>     │   │   │   │   │   │   ├── access_bp
>     │   │   │   │   │   │   ├── aggrs
>     │   │   │   │   │   │   ├── max_sample_us
>     │   │   │   │   │   │   └── min_sample_us
>     │   │   │   │   │   ├── sample_us
>     │   │   │   │   │   └── update_us
>     │   │   │   │   └── nr_regions
>     │   │   │   │       ├── max
>     │   │   │   │       └── min
>     │   │   │   ├── operations
>     │   │   │   ├── schemes
>     │   │   │   │   ├── 0
>     │   │   │   │   │   ├── access_pattern
>     │   │   │   │   │   │   ├── age
>     │   │   │   │   │   │   │   ├── max
>     │   │   │   │   │   │   │   └── min
>     │   │   │   │   │   │   ├── nr_accesses
>     │   │   │   │   │   │   │   ├── max
>     │   │   │   │   │   │   │   └── min
>     │   │   │   │   │   │   └── sz
>     │   │   │   │   │   │       ├── max
>     │   │   │   │   │   │       └── min
>     │   │   │   │   │   ├── action
>     │   │   │   │   │   ├── apply_interval_us
>     │   │   │   │   │   ├── core_filters
>     │   │   │   │   │   │   └── nr_filters
>     │   │   │   │   │   ├── dests
>     │   │   │   │   │   │   └── nr_dests
>     │   │   │   │   │   ├── filters
>     │   │   │   │   │   │   └── nr_filters
>     │   │   │   │   │   ├── ops_filters
>     │   │   │   │   │   │   └── nr_filters
>     │   │   │   │   │   ├── quotas
>     │   │   │   │   │   │   ├── bytes
>     │   │   │   │   │   │   ├── effective_bytes
>     │   │   │   │   │   │   ├── goals
>     │   │   │   │   │   │   │   └── nr_goals
>     │   │   │   │   │   │   ├── goal_tuner
>     │   │   │   │   │   │   ├── ms
>     │   │   │   │   │   │   ├── reset_interval_ms
>     │   │   │   │   │   │   └── weights
>     │   │   │   │   │   │       ├── age_permil
>     │   │   │   │   │   │       ├── nr_accesses_permil
>     │   │   │   │   │   │       └── sz_permil
>     │   │   │   │   │   ├── stats
>     │   │   │   │   │   │   ├── max_nr_snapshots
>     │   │   │   │   │   │   ├── nr_applied
>     │   │   │   │   │   │   ├── nr_snapshots
>     │   │   │   │   │   │   ├── nr_tried
>     │   │   │   │   │   │   ├── qt_exceeds
>     │   │   │   │   │   │   ├── sz_applied
>     │   │   │   │   │   │   ├── sz_ops_filter_passed
>     │   │   │   │   │   │   └── sz_tried
>     │   │   │   │   │   ├── target_nid
>     │   │   │   │   │   ├── tried_regions
>     │   │   │   │   │   │   └── total_bytes
>     │   │   │   │   │   └── watermarks
>     │   │   │   │   │       ├── high
>     │   │   │   │   │       ├── interval_us
>     │   │   │   │   │       ├── low
>     │   │   │   │   │       ├── metric
>     │   │   │   │   │       └── mid
>     │   │   │   │   └── nr_schemes
>     │   │   │   └── targets
>     │   │   │       ├── 0
>     │   │   │       │   ├── obsolete_target
>     │   │   │       │   ├── pid_target
>     │   │   │       │   └── regions
>     │   │   │       │       ├── 0
>     │   │   │       │       │   ├── end
>     │   │   │       │       │   └── start
>     │   │   │       │       └── nr_regions
>     │   │   │       └── nr_targets
>     │   │   └── nr_contexts
>     │   ├── pid
>     │   ├── refresh_ms
>     │   └── state
>     └── nr_kdamonds
> 
> 29 directories, 60 files

I'd suggest referencing the document [1] instead.

[1] https://origin.kernel.org/doc/html/latest/admin-guide/mm/damon/usage.html


Thanks,
SJ

[...]

