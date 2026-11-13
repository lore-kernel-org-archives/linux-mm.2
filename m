Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD3BA606A327
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=gD7wLNx/
Received: by kanga.kvack.org (Postfix)
	id 32BC96B067E; Thu, 12 Nov 2026 22:37:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1554F6B067F; Thu, 12 Nov 2026 22:37:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC7B36B0680; Thu, 12 Nov 2026 22:37:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 560C46B067E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:37:04 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC12DA067F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:37:03 +0000 (UTC)
X-FDA: 85428684726.02.8CF3276
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf30.hostedemail.com (Postfix) with ESMTP id DFEBE80002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:37:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="gD7wLNx/";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794541022;
	b=VvQYbQUKM0g3u/HgPd0rOSveJZQQ4zEr7JKwVj0nAwAOrHjvB7A24tgbPUqerAHHrAXhjj
	zkRxRHbgZzBJFRcrWHTixSvCYuNazyZ6YEJw2HVbRHRpmcw1/jm7vM6NkTjg6yyZLRMmtO
	PeQXjyPTZeqW6thHUBsL9RPtbUZJ52k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794541022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IquPgstZG7/phMK18xcbdIMOKbX4eZObEEJjGm9VUc0=;
	b=FWzoIjTvBQda1VcpbFLM98X8N9Scjv/n1Gvjv3HbUEFGtSc1c4Zzh9MYp/VDc0UvTAy4GD
	yv4rCx0BUr8OERD++2EiSVx7LbBRmCkzbNo0xreG4r76lVQCYJ+PMD7E0I7COGoVW/TGDU
	HaJsfwxqMSsZ0PAxvpqcUwwIsFhrI7o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="gD7wLNx/";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794541016; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=IquPgstZG7/phMK18xcbdIMOKbX4eZObEEJjGm9VUc0=;
 b=gD7wLNx/ktP6Mzx4Ixd8qC3MWUMY09IdNgBosFyFtUlo7XaOzs47rg/15SZGGS5XfrFp+/
 YNRFRxuKBY/FKn3urGy0Buo2sLWORM3o1+BjFaZmMafanjZJ1heBJ99FKcoC2FpMXtUaix
 rxqivTSZtkhW6+YCnur1sdKXfsJ5i2xuobQbjUrMbrEdIEqP+sqh/PaLiBuiKldZlnYb1j
 1H+se/B/T2GptN5RViz4dComeoBeye8hEcy/3ddxonTw+755RZEllrMf2ForFOHkAE8wrC
 j50Ukr9BgWVhPKsHJwtRCzWijLFGB8Im8Djr1sCxpHZekvYf0/lG4zhdHhMRdw==
Message-Id: <87b21fe2-5fe2-469b-8357-77cd5cd754ff@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Subject: Re: [RFC v2 0/1] mm: add source selector to memory.reclaim
Date: Fri, 13 Nov 2026 11:36:33 +0800
References: <20261102070440.16262-1-lizhe.67@bytedance.com> <avZOsc-jTr7n8Q_y@devbig011.atn3.facebook.com>
To: "Joshua Hahn" <joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26af685d7+e15a3d+kvack.org+lizhe.67@bytedance.com>
In-Reply-To: <avZOsc-jTr7n8Q_y@devbig011.atn3.facebook.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
User-Agent: Mozilla Thunderbird
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>, 
	<ljs@kernel.org>, <mhocko@suse.com>, <muchun.song@linux.dev>, 
	<rakie.kim@sk.com>, <roman.gushchin@linux.dev>, <shakeel.butt@linux.dev>, 
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<linux-doc@vger.kernel.org>, <cgroups@vger.kernel.org>, <ziy@nvidia.com>, 
	<ying.huang@linux.alibaba.com>, <weixugc@google.com>, 
	"Johannes Weiner" <hannes@cmpxchg.org>
X-Rspamd-Queue-Id: DFEBE80002
X-Rspamd-Server: rspam12
X-Stat-Signature: 6cmzrti6j5jpwipqpde8jykmbe1jux65
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794541021-659002
X-HE-Meta: U2FsdGVkX1+NOe6q0hfMPPH455/IbqYDuLAcaZApi4sRtMJ35hPHZ6us4ei6L3/00hvhTNR8+zF2wOu5ZfEgX2bcwXhwb47zmBtGmC/N3NydQIjLXRWzjKIeFcitX5D6tKqeF8uu7lJ5VVZ5WCGsdoxR1rCqtUP1MsO+q1Mv/u4I/mkYRMu17NQuK+pWZMNI6gDhA29N/3QmytQ7peOb9KodMHc8PfUSea31AlGG07Ti1NR3CBuUkO04cKX7sT9vuO2GWY9Xav+Za0jIx2sIwz1WWz58q61ifoS6ZhQwyvwexzlzF6TOex166Q5dDcSTx/Uc71uR4BoqNb9Wz2EngcT3J6P7gwH7CPHI7bbAM/b27lpWdnAHz0oGY+5hxHj8pWkD3k8ZFAuJ+zFwLF/F1qjR+G0FwBYrQltFjpGTNeyJTOhREtCZOeVO0WO4WzI4HLLJHVHtQV+tffws/4YS1Y6QaVY5pTHejeyR5bsORlMu+ggZvaLZuUxsmXrL7RUE7O70KgmLDWMaDkX8CjWBv+as1vV/wSA9zlbpgVtI+tH1p0fMl/XWAvRKgOTIZcpvxzyIbcWTV84Zz3wvFNcKmoj9m73yUINFtkwKoh+qJabt9oRwpUs1J19ViD3xyvP6WAycceLhufE0yxGLbR+axzZCIK5Bqw+2EPjIXDX7IBtJndGwVz1R3Uh4EuXhol8TShJdzQoyZKBqqkV5QpezyG0GU8MTOKiGXzLateNtSEHRRKGis6hKAHsQsHXkhbpo0kgrGrHpQ/6LjvXXtTdEbgeAksnJWPi5SNDbJ727bFr7vmP8sjPtZXW6G0FeEfKzbZL726yqMJMSLjeW/9D2q11jSq75zRyNPO+qCTDCOC1br3boYbfM4jIHpi2x9/AsRw3XsPa3CWqk6ZL8QBfKf4rr1SQfsYmdR8UrzrnhP3NNe67ulVOeB/eoJ+WkvbvsZQeWj+p/N4lraimAk1B
 vpLMhCyh
 2mJV7aozyC4FEHw2Bkqur88TUbCSZatmA6M7WAAf4BmauYP4Ba0BvEzk7ftwIaugNDUUiqncS7mbtDHMG/Gq2/3Jz+bf9HwFlf6WL/xlo0ey+QWUzQ2T+u6hpvRY3bgbrVznS/vaqR3KGCwBvkQko9oNASvLawHBTN1vIAqGM3CyQMW2OS4SkJISodMckBPK/nHHLSS1EIZIEAPGGcEmAn5d5l2yLXE1i2kPN4/a8iVLdaiRprceyrRWnEEtDH6PIBrJjXb5iIbz0DGIc11/Olm7DQTdDsqfMMlMgrFamLZhzRTOGmGVRXEWQlhdqt2Y0T6l3Q9IMcxQJ3riAFg3RJzPkydjmW8OfP28AvV3bYJe/tTlBiYqxrFcg5O1JIIiWRjm1eolrG4ttIRkI/oXCxxz3ReEv+cR7WMRpqdd6Q5LMWsQfryzbRUcDbRmcv8C0NhULD6bRRQeDj/uGHHL+2uY18Aua12EitU0siTaSqn+tGev4UwA8JF2ngMQ/1yVgwhDuWcT8Iixy9IbXZ7QW9IH64cnaSNSf02YbsdlIlZozf2GGVOBmCTDCu9J9pcQfYJLd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 7:48 AM, Joshua Hahn wrote:
> On Mon, Nov 02, 2026 at 03:04:39PM +0800, Li Zhe wrote:
>
> Hi Zhe,
>
> Sorry that I got to this so late. I must have missed it in my inbox
> somehow!


Hi=C2=A0Joshua,

Thanks for the review and suggestions!


>
>> memory.reclaim is a useful proactive reclaim interface for memcgs, but
>> tiered memory makes "reclaim N bytes from this memcg" underspecified for
>> userspace controllers that manage memory placement across tiers. The
>> kernel reclaim path may demote some folios and evict others. Without a
>> way to declare where reclaim pressure should be applied, userspace can
>> only reclaim from the memcg as a whole and observe one aggregate progres=
s
>> value.
> Does this series do anything to distinguish demotions from evicting?
> If not, I'm not sure why it is mentioned above.


No, it does not. Thanks for pointing this out. It is indeed unnecessary
to mention it here.

>
>> There is prior history here [1]. The old nodes=3D proposal tried to let
>> memory.reclaim scan selected NUMA nodes, but the discussion left several
>> ABI questions unresolved:
>>
>> - nodes=3D did not clearly say whether the mask was a source selector, a
>>    reclaim domain, or a demotion-target constraint.
>> - The implementation did not apply the mask to the whole reclaim path,
>>    so demotion could allocate outside the mask. If userspace interpreted
>>    the mask as a domain or target constraint, the ABI did not provide
>>    that.
>> - Selecting top-tier nodes could become an implicit way to request
>>    demotion without uncharge. That would make userspace depend on a
>>    particular reclaim policy and could make future policy changes hard.
>> - The separate completion-accounting question remained: demotion can
>>    count as reclaim progress even though memory.current is not reduced.
>>
>> This series takes a narrower approach. It adds a typed source=3D key whi=
ch
>> declares only the resident source to which the existing memory.reclaim
>> path should apply pressure. It is not a demotion target selector, not a
>> demotion-only goal, not an eviction-only goal, and not a change to the
>> existing completion accounting. Leaving source unspecified preserves the
>> existing memory.reclaim behavior.
> Right, I was a bit confused why you presented not distinguishing between
> demotion and eviction as a problem, since this patch just preserves
> the existing behavior for reclaim.


Agreed. The patch only selects the reclaim source and otherwise preserves
the existing memory.reclaim behavior. I will make that clearer.

>
>> In that sense, this series extends node-scoped reclaim pressure to the
>> memcg memory.reclaim interface. The existing node memory_reclaim
>> interface can apply pressure to a node, but it is not scoped to a
>> particular memcg. This series lets userspace apply the same kind of
>> source-scoped pressure to a cgroup's resident memory on selected nodes,
>> while still using the normal memcg reclaim path.
>>
>> The typed source=3D form also follows a direction that has recently been
>> discussed for memory.reclaim. In the zswap proactive writeback series,
>> the interface was changed from a one-off zswap_writeback_only key to
>> source=3Dzswap so that other reclaim sources could be selected in the
>> future [2][3]. This series uses the same extensible key shape, but
>> defines a different source class: resident NUMA nodes. source=3Dzswap
>> bypasses ordinary reclaim and performs zswap writeback; source=3Dnodes:
>> <nodelist> only constrains where the normal memcg reclaim path applies
>> pressure.
>>
>> The main benefit of this series is to give userspace a steering knob for
>> per-node memory placement control. A tiering controller can still build
>> per-tier policy on top of it by translating a tier to its node list, for
>> example from /sys/devices/virtual/memory_tiering/memory_tierN/nodelist.
>> It can then apply reclaim pressure to the nodes that should be relieved.
>> For example, it can apply pressure to top-tier nodes so that, under the
>> existing tiering policy, cold folios can usually be demoted to lower
>> tiers. Another controller may first reclaim from lower-tier nodes so tha=
t
>> later top-tier reclaim has room for demotion. A controller can also
>> reclaim from terminal-tier nodes when it needs actual charge reduction.
>>
>> The existing memory.reclaim interface cannot express this. It applies
>> pressure to the memcg as a whole, so on a multi-tier system the kernel
>> may make progress in a tier different from the one userspace is trying
>> to control. That makes a userspace feedback loop for tier ratios
>> ineffective: the controller can observe that a specific node or tier is
>> over its desired resident footprint, but it cannot direct the next
>> reclaim request to the corresponding source nodes.
>>
>> This version only adds source=3Dnodes:<nodelist>, which is the basic
>> source selector. More convenience selectors can be considered later, but
>> the tier use case is already expressible by resolving a tier's current
>> nodelist in userspace and passing that nodelist to
>> source=3Dnodes:<nodelist>. Starting with the node-based interface keeps =
the
>> ABI smaller while preserving the source=3D namespace for future selector=
s.
>>
>> The remaining issues from the old discussion are intentionally left out
>> of this series. If userspace needs to control demotion targets, that
>> should be a separate target/demotion-policy ABI rather than folded into
>> source=3D. If userspace needs a strict "bytes actually uncharged"
>> completion mode, that should be discussed as a separate accounting or
>> goal extension because it would change the observable meaning of
>> memory.reclaim progress. This series only adds source selection for the
>> existing reclaim policy.
>>
>> Testing:
>>
>> I ran a simple userspace feedback controller on a CXL test machine. The
>> machine had nodes 0-2 as the DRAM tier and node 3 as the CXL tier. The
>> basic matrix used node 0 as the DRAM source and node 3 as the CXL
>> source for the target memcg, with fio and stress-ng as the load
>> generators. The controller:
>>
>> - read anon/file bytes from memory.numa_stat by node;
>> - aggregated them into DRAM and CXL resident bytes;
>> - targeted a 1:1 DRAM:CXL resident ratio for the target memcg;
>> - selected the side above 55%;
>> - wrote memory.reclaim with source=3Dnodes:<selected nodes>; and
>> - slept for the configured control period before the next sample.
>>
>> The controller loop was approximately:
>>
>> while running:
>>          stat =3D read_memory_numa_stat()
>>          dram =3D resident_bytes(stat, dram_nodes)
>>          cxl =3D resident_bytes(stat, cxl_nodes)
>>          total =3D dram + cxl
>>
>>          if dram > total * 0.55:
>>                  source_nodes =3D dram_nodes
>>                  excess =3D dram - total / 2
>>          else if cxl > total * 0.55:
>>                  source_nodes =3D cxl_nodes
>>                  excess =3D cxl - total / 2
>>          else:
>>                  sleep(period)
>>                  continue
>>
>>          bytes =3D clamp(excess * gain, min_step, max_step)
>>          write(memory.reclaim,
>>                "$bytes source=3Dnodes:<source_nodes>")
>>          sleep(period)
>>
>> The requested reclaim size was proportional to the excess bytes, with
>> per-workload min/max bounds. I tested 1G, 5G, 10G, 20G and 50G
>> workloads with 1s, 2s, 5s and 10s control periods. A run was considered
>> within target when max(abs(dram_ratio - 0.5), abs(cxl_ratio - 0.5)) was
>> not greater than 5 percentage points.
>>
>> Basic feedback-controller matrix, final deviation from the 1:1 target:
>>
>> The 1s, 2s, 5s and 10s columns are controller periods.
>>
>> The file-cache-CXL-high case used fio under numactl to create about 25%
>> DRAM and 75% CXL page cache. It reached within 5% by at most the
>> eighth control cycle, and all 20 runs ended within 5%.
> These results are really confusing. What does the % mean here?
> % deviation from a 50-50 split? I want to review the code but I want
> to understand what the test is actually trying to do first.


Yes, the percentage is the final deviation from the 50:50 target:

 =C2=A0 max(abs(dram_ratio - 0.5), abs(cxl_ratio - 0.5))

I should have stated that directly. I will make the test metric clearer
in v3.

>
> In any case, I think the important tests to demonstrate the code are:
> - How does this perform when the entire system is under pressure?
> - How are multiple cgroups simultaneously present on the host dealt
>    with? Are they also able to manage an effective split?


That makes sense. I will try to extend the tests to cover system-wide
pressure and multiple active cgroups in v3.

>
>> size  1s     2s     5s     10s
>>   1G   3.96%  3.96%  4.45%  3.96%
>>   5G   2.65%  2.75%  2.65%  2.65%
>> 10G   2.65%  2.68%  2.65%  2.69%
>> 20G   2.65%  2.66%  2.66%  2.64%
>> 50G   4.31%  4.31%  4.31%  4.31%
>>
>> The anon-DRAM-high case used stress-ng under numactl to create
>> anonymous memory on DRAM and used swappiness=3Dmax so that the normal
>> reclaim path could demote or reclaim anonymous memory. It reached
>> within 5% by at most the seventh control cycle, and all 20 runs ended
>> within 5%.
>>
>> size  1s     2s     5s     10s
>>   1G   0.15%  0.02%  0.16%  0.02%
>>   5G   3.16%  3.13%  3.14%  3.13%
>> 10G   3.13%  3.13%  3.15%  3.12%
>> 20G   3.12%  3.13%  3.12%  3.12%
>> 50G   1.88%  1.88%  1.88%  1.88%
>>
>> For comparison, I also ran the same controller and workloads without
>> the source=3Dnodes selector. The controller still chose the side above t=
he
>> target and computed the same request size, but wrote plain
>> memory.reclaim without a source constraint.
>>
>> case                  final <=3D5%  reached <=3D5%  worst deviation
>> file-cache CXL high        1/20          1/20     50.00%
>> anon DRAM high            20/20         20/20      5.00%
>>
>> This shows why the source selector matters for placement control. In
>> the file-cache-CXL-high case, plain memory.reclaim could not reliably
>> control the target ratio without source=3Dnodes. In the anon-DRAM-high
>> case, plain memory.reclaim worked well. This is likely because, in this
>> setup, the whole-memcg reclaim walk reached DRAM nodes before CXL nodes,
>> so it already applied pressure to the over-target DRAM side first for
>> this workload.
>>
>> I also ran a disturbed case with external reclaim and demotion activity.
>> The target memcg used stress-ng under numactl to create about 25% DRAM
>> and 75% CXL anonymous memory. NUMA demotion and zswap were enabled, and
>> watermark_scale_factor was raised to 3000 so background reclaim became
>> visible in a short run. A ballast cgroup kept DRAM free memory low, and
>> a separate CXL-heavy cgroup kept reclaim activity present on the CXL
>> tier. The result below was measured on the target memcg.
>>
>> During the matrix, pgdemote_kswapd increased in 16/20 runs. The
>> CXL-free-down/DRAM-free-up/pgdemote pattern appeared in 13/20 runs.
>> Even with that external activity, the target memcg controller still
>> drove its own DRAM:CXL resident ratio toward 1:1.
>>
>> Disturbed case, final deviation from the 1:1 target. The 1s, 2s, 5s and
>> 10s columns are controller periods:
>>
>> size  1s     2s     5s     10s
>>   1G   1.18%  1.11%  1.11%  1.42%
>>   5G   2.14%  2.06%  2.14%  2.14%
>> 10G   2.13%  2.10%  2.15%  2.11%
>> 20G   2.15%  2.23%  2.15%  2.43%
>> 50G   4.87%  4.87%  4.89%  4.87%
>>
>> All 20 disturbed runs reached within 5% by the third control cycle and
>> ended within 5%. This does not make memory.reclaim a one-shot footprint
>> guarantee, but it shows that source=3Dnodes can act as a useful
>> feedback-loop actuator.
>>
> Zhe, it would be great if the commit message could be a lot, lot
> shorter. I feel that this is just really too hard to read. And I'm not
> sure if there's a need to have a separate cover letter for a single
> patch.
>
> Please, I feel like this is really difficult to read. I think the
> commit message could be as short as 3 paragraphs and I think it would
> still capture everything that you're trying to say.


Agreed, and sorry for making this too long. I will make v3 much shorter
and drop the separate cover letter if it remains a single patch.

>
> Sorry again for the super late reply, Zhe. I'll be more on top of review
> next time! Have a great day,


Thanks again for the review and suggestions!

Thanks,
Zhe

> Joshua
>
>> References:
>> [1] https://lore.kernel.org/all/Y5bsmpCyeryu3Zz1@dhcp22.suse.cz/
>> [2] https://lore.kernel.org/all/20260629112032.20423-1-jiahao.kernel@gma=
il.com/
>> [3] https://lore.kernel.org/all/20260629112032.20423-5-jiahao.kernel@gma=
il.com/
>>
>> Li Zhe (1):
>>    mm: add source selector to memory.reclaim
>>
>>   Documentation/admin-guide/cgroup-v2.rst |  9 +++++
>>   mm/bpf_memcontrol.c                     |  3 +-
>>   mm/internal.h                           |  3 +-
>>   mm/memcontrol-v1.c                      |  6 ++-
>>   mm/memcontrol.c                         | 11 ++++--
>>   mm/vmscan.c                             | 49 +++++++++++++++++++++++--
>>   6 files changed, 70 insertions(+), 11 deletions(-)
>>
>> ---
>> v1: https://lore.kernel.org/all/20261019141401.11927-1-lizhe.67@bytedanc=
e.com/
>>
>> Changes since v1:
>> - Reworded the cover letter and documentation to describe the interface
>>    as applying reclaim pressure to a selected resident source.
>> - Added the lower-tier use case where userspace reclaims from a lower
>>    tier first so that later top-tier reclaim has room for demotion.
>> - Dropped patch 2, the tier convenience selector, for now. Tier-aware
>>    userspace can resolve a tier to a nodelist and use source=3Dnodes.
>> - Added references to the zswap proactive writeback discussion, which
>>    also uses the typed source=3D form to keep memory.reclaim extensible.
>> - Added CXL feedback-controller test results using fio and stress-ng
>>    load generators, including a no-source baseline.
>>
>> --=20
>> 2.20.1

