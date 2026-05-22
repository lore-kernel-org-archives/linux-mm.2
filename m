Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3CE9CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:12:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D591D6B00AC; Fri, 22 May 2026 11:12:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D318D6B00AE; Fri, 22 May 2026 11:12:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C47886B00B3; Fri, 22 May 2026 11:12:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC5356B00AC
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:12:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4337C929EA
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:12:10 +0000 (UTC)
X-FDA: 84795396420.28.750B516
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf07.hostedemail.com (Postfix) with ESMTP id C05604000C
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:12:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j2w0GEj9;
	spf=pass (imf07.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779462728; a=rsa-sha256;
	cv=none;
	b=qk1F/TolODO1wYS305P9JU4c7kQfoARHQfwY/smEeSI375gDzOd5E1WkixSC6fqfI5Ss2b
	EFoFLpZNplrBIQggVQYKfxoA9ypXqEQujn/ZtR3iwIlVCqrxBmJT4zKR3B8LwmIvmeS4FK
	z+drMCm4A0YOIMDVGIJ2rysbeAbXIuA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j2w0GEj9;
	spf=pass (imf07.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779462728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vUXJwgDldc0m2qgpCH106bKsw/W7QUvZVpUyUS1MkV0=;
	b=WF+HrMZL3FqvExz2cRlTbzzUIFXTeN/qVX1a1ARSvYF9VAfAVEdJNaxQge8olGDEijUtP0
	NLyDfWiKgD6D2hbyIsRVeNPgfRQEFPE2dZBI/kwNtKacjwvsrFYVPZHBe7SzPT1rfaRlTz
	BDngPXCWfdU9o9TMmBU31nm+i1pP+IY=
Message-ID: <ddc3eb87-e34f-400f-a1d1-b807b340ff33@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779462721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vUXJwgDldc0m2qgpCH106bKsw/W7QUvZVpUyUS1MkV0=;
	b=j2w0GEj9MyWztok5/mQWcess+NUWYjTQCjB43C6jMiiUfM6P1Cnic7q8Ggz5tGFEXtiOLd
	790HyN18nng7Kyu5sS1abWTkzlJOcoBY22HNOEvRcVq9bcpEMC4OzkSUWNXE88LzdfV543
	KapCoIvcbiia8xOD4n4LAyDTW6yiHgA=
Date: Fri, 22 May 2026 23:11:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] mm/damon/core: detect internal variation above
 max_nr_regions/2
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Shu Anzai <shu17az@gmail.com>, Jiayuan Chen <jiayuan.chen@shopee.com>,
 Quanmin Yan <yanquanmin1@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260522024228.87328-1-sj@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <20260522024228.87328-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: C05604000C
X-Rspamd-Server: rspam03
X-Stat-Signature: asmhntngtm6t3ara8uuhzgrsb1j4ys3f
X-HE-Tag: 1779462726-576023
X-HE-Meta: U2FsdGVkX193TmvIN7lUKJWm5X6SMtwdhrg5+qcFM3uXXppyfRrrHqAqCj9rfMsVn/946x/Gh+CLvDILnD55uIojSf4/OsRRcqJS1V2KQFRt/b7BuxcQ6C+7fYtekvpMF+x6zqg6jvK+8ZEVLOcxPGmW+pS5yD8e3fFGho8AhYWWX/a2G5o9sAv0MwYiJ5lkIXqGKYYsKE2DuYxAWUAysgkJgNjUJSBMcAdajX/NxrR5aOE9gD12hpWuEX/xcqkCHXlaHxuwk01AAxgsxP3Zkz7aGo16dKQ1dbBQF99LwYIy75hItRvYNCkVsQnEsBg+GXsYWHIjTGo1gTs4YRywW3oXAw5lC3RuZ3Gg67O9Anuzn/ndOQkynfRTgR4KXgaSVyJg1LbubnH9kOAPLwO40MVpouW25Wgr1Q5O4uBuVwt897ICgyRb1P9p+k/0JB+BSuniA6X3NYrLNwzS/nd46Rku0wJSJOVNzh752K++5SoksTNs0RIxOh9yoId7eznflx57Rkd0soA39eKga0Ca4mqmYk68Logyet4PhnSHE03teP4Eh5hbVmPMaIvA0Qx8mLLcEYEGN66z1QtEApRB8MkqSWaAoi8B13fPGGbRvUn//2ihAN8uCh7rsgrjpAfWWLBi531KiafophB68+pwopuGVf0PX9E5IXu3b+ysSADg5ETduKJue9HSLEcjKbsLhlSpVGF0KNDbpKPBaOFEf3HHqJXlfcruWEkz9CSVgypDg8iZgeZ9r1LdLgIUEi9TgM57wjE8dT4zc7xq3Y8jb1XE1+1EJb2R3T7luiHhlZi1JdE25krtcxnzsfmxmWIvM1K83fXaJtjkiQ2OHoL0rWk5MeB03OuANMIHZEztDiuwsKV6AeEUp/H72Bvwpwl+nvVqa6J4itYjTN64NuCVQDRlX2OjpJcJ6CI8zFg/+mAFRoiWdCBQoZx2wDFlelxVz2jSXxNl+rm8THt0Zlx
 RbyMWMpB
 tbdk9oyKW5OBGlSG7dXiz2UrXzlE9gPjA5yXu8k4nnrXtozkAZ/hlQ3P0FX18wlrTg3cJGKoh4JoyF4JQ/Sh2fMcgq+MrBe6fyPa3VHMvyY1VnwggbyqVzBMPu3E8fJTzizeif/o4wk6I8kbPKnujZqlz6X8BF7bv07RKiUG9qONv+mChRxqKJNhHWjl0ceiK7EL59eBaNTpgwJNYqHTy2G9QuAygsxNzuyGd8mrQcuxlx9BRnUyFRLRE2T0gbTX/3UyDWLHm/giFp5DT5YFuYfdSlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, SJ

On 5/22/26 10:42 AM, SeongJae Park wrote:
> On Thu, 21 May 2026 23:07:11 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
>
>> Hi SJ,
>>
>> Thanks for taking a look.  Quick replies inline.
>>
>>
>> On 5/21/26 10:30 PM, SeongJae Park wrote:
>>> Hello Jiayuan,
>>>
>>> On Thu, 21 May 2026 12:52:22 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
>>>
>>>> kdamond_split_regions() bails out early when nr_regions is already
>>>> above max_nr_regions / 2.  A large region that picks up new internal
>>>> variation after that point never gets split, so we lose visibility
>>>> into its hot/cold structure.
>>>>
>>>> We hit this with damon-paddr on hugepage workloads and damon-vaddr
>>>> on processes that mmap a large anonymous range.
>>>>
>>>> On our production tree we added a current_nr_regions counter (no
>>>> good upstream home for it yet, so it's not in this series).  We saw
>>>> nr_regions never getting close to max_nr_regions, and the picture of
>>>> the access pattern was too coarse.
>>> Is 'current_nr_regions' somewhat showing the number of DAMON regions?  If so,
>>> you could also get the information from nr_regions field of damon_aggregated
>>> tracepoint.  I'm wondering if you considered using that but found a problem
>>> that made you have to implement the internal change.
>>>
>>> I will be happy to help removing such downstream changes.
>>
>> Yes, same data as the nr_regions field in damon_aggregated.  The downstream
>>
>> counter was just for convenience -- easier to cat a sysfs file than to wire
>>
>> up tracing.  Even the tracepoint covers it, It's cost to much for
>> Grafana to just get
>>
>> a metrics by tracepoint.
> Makes sense.  And I think this deserves to be upstreamed.  Some minor
> modifications might be needed to your current implementation, though.  Please
> feel free to send a patch to start the discussion, if you want.


On the sysfs counter -- agreed, same data as the tracepoint. I'll
look into a suitable location.


>>
>>>> Example with max_nr_regions == 1500.  A target ends up with 799
>>>> small hot/cold regions plus one big region (an earlier merge
>>>> collapsed a uniformly-accessed range into a single piece):
>>>>
>>>> H:hot
>>>> C:cold
>>>>
>>>>         r1     r2     r3                 r800
>>>>       HHHHHH|CCCCCC|HHHHHH|...|HHHHHH..........................|
>>>>
>>>>       nr_regions = 800  >  max_nr_regions / 2 = 750
>>>>
>>>> Now a cold subarea shows up inside r800:
>>>>
>>>>         r1     r2     r3                 r800
>>>>       HHHHHH|CCCCCC|HHHHHH|...|HHHHHH........CCCCCC.............|
>>>>
>>>> The small regions can't merge with each other (their access counts
>>>> differ), so budget never frees up.  r800 can't be split because
>>>> nr_regions > max_nr_regions / 2 returns early.  The cold subarea
>>>> stays invisible.
>>> I agree this corner case could theoretically happen.  But, would the small
>>> regions have the current pattern forever?  On real world systems having dynamic
>>
>> I agree with the point that this is a corner case. But it's not
>> transient for us.
> Thank you for sharing this nice information.
>
>> On a production setup with max_nr_regions = 20000, nr_regions sits at
>> 11k-12k
>>
>> for extended periods. There are occasional bursts (e.g. from offline
>> pods), then things settle
>>
>> back without ever reclaiming the budget.
> Could you please clarify a little bit more?  What is the occasional bursts, and
> how offline pods contribute to that?  What "reclaiming the budget" means?
>
> Also, do you have some measurements that shows this problem and how much of it
> is removed by this series?
>
>>
>>> access pattern, I guess those small regions may not keep the shape forever, and
>>> give chance for the large region to be split.  Am I missing something?
>>>
>>> My theory also implies that this kind of situation could happen at least
>>> sometimes for temporal periods.  In other words, it could happens too
>>> frequently and too long to be problematic.  But, in the case, maybe the user
>>> could mitigate the issue by increasing the max_nr_regions.  I'm curious if you
>>> considered that direction and found a problem that I don't expect for now.
>>>
>>>> Patch 1 lets this path still split regions that just changed
>>>> (age == 0),
>>> Why 'age == 0' means it is a good candidate to split?  Because it means its
>>> access frequency is anyway unstable?  Or are there other reasons?  More
>>> clarification would be helpful.
>>
>> Yes, age == 0 means the region's access count drifted past the merge
>> threshold in
>> the last aggregation -- the strongest signal it just changed internally.
>> Regions with age > 0 are stable; splitting them tends to oscillate (the next
>> merge cycle pulls the halves back together and we waste the budget).
> Thank you for confirming this.  Yes, that sounds good approach to me.  But
> because this is a core behavior, I'd like to be careful more than usual.  I
> will spend more time at thinking if I'm missing something, and if this is the
> best approach.  If you have measurements that I asked above and can share, that
> will also be helpful.


We considered selecting regions randomly past max/2 (which is what our
downstream tree does).  Random selection converges to higher
nr_regions faster.  We picked age == 0 for upstream because:

- It's DAMON's own signal that the region's nr_accesses just
   crossed the merge threshold -- i.e. the access pattern is
   currently unstable.  Splitting an unstable region is more likely
   to reveal new internal structure than splitting a stable region

- It's selective by design, so it leans conservative on a core
   code path.  In our tests it still reaches the effective
   refinement we need (e.g. 160-180 at max_nr_regions = 200), just
   more gradually than random selection would.

We thought a selective, signal-based filte.


>>>> up to whatever budget is left under max_nr_regions.
>>>> If a split turns out useless, the next merge cycle undoes it.
>>> I'm again curious why the user cannot just increase max_nr_regions.
>> It works as a workaround, but it isn't free: higher max means more sampling
>> work and more memory,
> It would depend on the real number of distinct access patterns.  I understand
> the number is really high on your use case.  Again, if you have measurements
> and could share, that will be very helpful.
>
>> and 20000 is the ceiling we actually want to live
>> with.  Bumping to 30000 just so the splitter has room to make progress
>> between max/2 and max is wasteful -- we don't actually want to spend the
>> resources for 30000 regions.
> Makes sense.
>
>> The real issue isn't budget waste, it's that once nr_regions crosses max/2
>> the splitter has no recovery path -- it returns immediately even when
>> there's
>> variation worth refining, and merges don't help because the small regions
>> have different access counts.  nr_regions just sits between max/2 and max,
>> and new variation inside a large region goes undetected.  The patch gives
>> that path a way to keep refining within whatever budget remains, instead of
>> asking users to over-provision max.
> Yes, I agree.  Nonetheless, as I mentioned above a couple of times, if you have
> and could share measurements that showing how big the problem is and how much
> of it this change can solve will be very helpful.
>

Our downstream paddr has per-cgroup tweaks, so I don't think those
numbers would be that meaningful for upstream review.  Here's a clean
upstream-paddr reproducer instead.

paddr config:
```shell
ADMIN=/sys/kernel/mm/damon/admin

echo 1 > $ADMIN/kdamonds/nr_kdamonds
echo 1 > $ADMIN/kdamonds/0/contexts/nr_contexts
CTX=$ADMIN/kdamonds/0/contexts/0
echo paddr > $CTX/operations

# Using stress-ng for hot memory.  Walking a 256M chunk takes around
# sample=50ms, aggr=1000ms, update=1s
echo 50000     > $CTX/monitoring_attrs/intervals/sample_us
echo 1000000   > $CTX/monitoring_attrs/intervals/aggr_us
echo 1000000  > $CTX/monitoring_attrs/intervals/update_us

# Without any cap nr_regions usually settles around 300+ on this
# workload, so max=200 makes the corner case easy to hit.
echo 10   > $CTX/monitoring_attrs/nr_regions/min
echo 200 > $CTX/monitoring_attrs/nr_regions/max


echo 1 > $CTX/targets/nr_targets
echo 1 > $CTX/targets/0/regions/nr_regions
echo 0 > $CTX/targets/0/regions/0/start
# 32C 16G machine
echo $((16 * 1024 * 1024 * 1024)) > $CTX/targets/0/regions/0/end

echo 0 > $CTX/schemes/nr_schemes

echo on > $ADMIN/kdamonds/0/state
```


Workload -- cold producer first, then a few hot producers right after,
so cold and hot pages get interleaved across physical memory:
```shell
# Cold: 4 GiB mmap, touch every page once, then sleep
python3 -c '
import mmap, time
size = 4 * 1024**3
m = mmap.mmap(-1, size, mmap.MAP_PRIVATE | mmap.MAP_ANONYMOUS)
for i in range(0, size, 4096):
     m[i] = 1
print("cold allocated, sleeping")
time.sleep(86400)
' &

# Hot: 7 stress-ng instances, different vm-methods so the hot
# regions don't all look identical and merge into one
for m in walk-0a walk-1a walk-0d walk-1d incdec rand-set zero-one; do
   stress-ng --vm 4 --vm-bytes 256M --vm-method $m --vm-keep --timeout 0 &
done

```


After running for an hour:
1.Without this series: nr_regions stays at ~100 (max/2), doesn't recover
2.With this series:    nr_regions stays at 160-180

In real production this is actually pretty common.  Workloads keep
changing state and creating new access patterns, so nr_regions
naturally tends to live above max/2 most of the time -- which is
exactly where the corner case kicks in.  On our production box with
max_nr_regions = 20000, nr_regions sits at 11k-13k for long stretches
without ever clearing.

﻿Without this series the effective ceiling is just max/2.  Set max=200,
you cap at ~100.  Set max=400, you cap at ~200.


The 1-hour reproducer above is admittedly a bit of a toy -- I set
max=200 to force the corner case without having to scale up the
workload -- but it shows the same pattern: once nr_regions crosses
max/2 it just stays there.


The offline-pod example I mentioned earlier is just one workload that
hits this.  The mechanism isn't specific to that workload: any new
access pattern that shows up inside an existing region after
nr_regions crosses max/2 will stay invisible until something else
lowers nr_regions, which may never happen.

Thanks,
Jiayuan


> Thanks,
> SJ
>
> [...]

