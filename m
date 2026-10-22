Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C96C960A2603
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 09:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=QgXszFg8
Received: by kanga.kvack.org (Postfix)
	id E7BE76B02C8; Thu, 22 Oct 2026 05:44:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E532A6B02CB; Thu, 22 Oct 2026 05:44:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D91DC6B02CD; Thu, 22 Oct 2026 05:44:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B68406B02C8
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 05:44:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D8D971C412D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:44:22 +0000 (UTC)
X-FDA: 85349776764.20.59F04FF
Received: from va-2-114.ptr.blmpb.com (va-2-114.ptr.blmpb.com [209.127.231.114])
	by imf07.hostedemail.com (Postfix) with ESMTP id 671FB40006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:44:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=QgXszFg8;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792662261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OUGHKG75J/Ha1UT9SfogPm3T2YK7q5WmnJNj8nl5ncM=;
	b=hYwHAXxX5OfdaeGNflb74WxByQmQsbjS7C6mZsuTTs1bhIa/peTw99JZzV3mXN80sq0dsn
	woL4FVhXIMYDHSxNgUoS5aNklMVweqXw0wCSVv/vOQHulYB2GShCnYzb0N8Ou0Dd1Fvm1T
	Jmy4E3Pgh/D1P2dhLLEYkGNQKPzGPhw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792662261;
	b=GFd6V2kFdXMKm7sw58YZfAMw9fhP1PgHDQ7sQeSGFVXYdfnBMHkHHoUTCmjZx3riaqV97a
	0FgZX9xfYEUqawAARVYNKvSYk/JCq/o/mVsekANtuOE2zqkGsd2Ed0yx4NmmjzFU/H05kk
	bWN/vI6WMBxVvleCkkQS7ijm16s1hao=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=QgXszFg8;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792662252; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=OUGHKG75J/Ha1UT9SfogPm3T2YK7q5WmnJNj8nl5ncM=;
 b=QgXszFg8BQyFzMHr+mS9D6ndBB9hF1GzlRV9C+V1WtRI0Da2uvUB2pOW7NBZM91KwRp8ge
 ECBtD77JopJSEPqWADA2RGCbdf7HlvhOPgm5jeY0WEM0y2v4dR6+vFliA+LfOGIzagobu0
 ZXhAArMow6hYHmdIIsTdsSMcBSXl6TQNvhAJ4GADIBJmpXqZtc2LqaHnDuLrIxhZfzj0hc
 rnV2MJmkp9PmZx5bceIzAUPApsI/MhQ+YmpZcp5zCIHi5wY/EcEzbAbpdAdtmYbiR/D8Q4
 ozameHasAU8fGA7RTuzeaxBP4GVu2EYi9bL4yR0O8WyC/EPfdjdbMh0cRkGcVQ==
Date: Thu, 22 Oct 2026 17:43:49 +0800
Message-Id: <9b715272-3ed9-42da-a6ae-467e8ae00c0b@bytedance.com>
References: <20261019141401.11927-1-lizhe.67@bytedance.com> <atY-LD2AzCYATRii@gourry-fedora-PF4VCD3F> <30457046-a662-4ff7-a6a8-100398d7a806@bytedance.com> <179264138036.2549665.17429111144570830454.b4-reply@b4>
X-Lms-Return-Path: <lba+26ad9daea+a9fea6+kvack.org+lizhe.67@bytedance.com>
Subject: Re: [RFC 0/2] mm: add source selectors to memory.reclaim
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <ziy@nvidia.com>, 
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, 
	<ying.huang@linux.alibaba.com>, <ljs@kernel.org>, <mhocko@suse.com>, 
	<muchun.song@linux.dev>, <roman.gushchin@linux.dev>, 
	<shakeel.butt@linux.dev>, <weixugc@google.com>, 
	<cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
In-Reply-To: <179264138036.2549665.17429111144570830454.b4-reply@b4>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
User-Agent: Mozilla Thunderbird
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 671FB40006
X-Stat-Signature: 18eet3f4s9ugwpbzd88opnfdo16pr46s
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792662260-576619
X-HE-Meta: U2FsdGVkX19qihvqXiFPIMlP7kSN+KXO6whj/9JD639enlkn1i+idGYePfo1+tXq0nQmyFc8mpFtPXfGyDLXa66h96qgvHu7u1zK4ZUaQKIIsRI6tjwaypiv/M7cfPFenkNx6oJ7SaYMFIvHt+KBtGUFXvLRPwci2+wc/eMeBdDQedm9nfoU3cNo+orKlUNvv14v1CDNMkwBUbP9gB7btL1/LWSGMkl4YksuyjyQipZTbF/RTJWUIH2LuWcF6PM4OARH4wwGtffiLxjIxn58hCuxDqkf8U61aorzMyPK3VctU0w4kEjq0B6zPJUGl/boHBLZH/S1B5VskrXzLwos4yr97DKlKMOXpmQYji0DuYXml2IRYzHdv5T24kWVlQmjnWa/K28JdKKTN+j+i9WrErhbGoN/GJJO51u/OI/vxsXY/vtbkHBrsRgqD0m4trG5rp6nbjVSliPTBaB/yBUpaiJcI3BDaMPKmISfd97in2GEf3Vw0Cw9JD+Om5Ql+qQg2n61O6LHkOXKCH2GFmKTb0Wlb94RWAE/vCu9ivLrAkFQ7zzjkgNc8l39GZ+WQnkhOVx60FA+0jE/3/L9PbSL0ieNGJHT988s0sKH0B/kPLJ1i0ADkuFcvs6T9ICiqgiDGaGZYmQZV5CuK1ug7gplNUZHn91bpRyGY4LrJVmjwLW//1pYZNC4nVbDwsLjaynqitxia+g1OQ0/k03+04Ik+RVXELTpS7MvpPsmctkN69YWX9VZVsYPkmhDfLeIcKwk9VC91gsHv/4Euky+H0YxglQXiek2/968Wo+kLy0zVNOryi/6o+FekOVsjwTC1SY1R9B87mDIky/Kocm6yq/rCUavQ175FOMdqMIfbv0y7KvffE6FPrhbjoSOaLWWE4Yrv/t3eWSpl6bKwbeaM/iehKIODuvCllXxXKfbCndu+BN7QLW5MuiA6XwjuyIWoPvfFQVYOoNx/d9R4pl5jRf
 +ZYFA9NB
 hw91jb3IMzGNT2n79NxWIXmA5TMz6iki2WVCH47t7aneFIp7kKitCyUSnXhscr7+QoBPkzsIp3D5CwW+Xx/8H01J5b+wDGGGt755Co9rZHCMrkhWyfxHuSzoxqzTKVrYKa2ClDGjbxVRY6RBNab7Inx/+Pey48xCvQFKGn4hyXrtJncDFaCgzYY1e6FipUYgoNVZCRfRQn9dkaBPNeqpyofA/Tkt3DXaDTbcbsIWe+kHlCeordShXscmajEgEJQwv1FU/4Rs3U7FAAnWJA1PKCs13tuMu9r7JlE31fUtNBthvTXEED+eUQ8TMhDWnw3q3kgavYpDSXaw/dFKuWetFT6uA59bpWRxIYtUUvO0jFJ3kJDCLmr+YmQL4RXmRMgZlKu2sJzVNtfR2qo5kFALVOu+ZJKBuFKLXdg/SsGRTNWiCpTirMbnlxmz5NUr6gORAzjfu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/22/26 11:56 AM, Gregory Price (Meta) wrote:
> On 2026-10-20 21:01 +0800, Li Zhe wrote:
>> On 10/20/26 12:10 AM, Gregory Price wrote:
>>
>> I agree that the kernel reclaim and demotion behavior still has room for
>> improvement, and the watermark changes and the bottom-up proactive/async
>> reclaim idea you mentioned may be useful to explore for some tiering
>> scenarios. But I think there is also an unavoidable userspace policy
>> component here. The kernel can improve whole-cgroup reclaim, but it
>> cannot know every controller's placement goal.
>>
>> For example, one controller may want to keep a specific per-tier
>> resident ratio for a cgroup. Another use case, as Joshua pointed out in
>> another reply, is reclaiming from a lower tier first so that later
>> top-tier reclaim has room for demotion. A single default memory.reclaim
>> algorithm cannot express these per-cgroup policy choices.
>>
> The latter of these should probably be some level of the system default,
> that's why I brought it up as well.  (proactive reclaim should prefer to
> make progress from the coldest tier first, then work its way up).
>
> I'm not convinced a reclaim interface is the right way to affect a
> per-tier resident ratio policy.  That feels like a hack to get around
> solving the harder problem of something like tiered memcg counters
> (which would otherwise drive reclaim to work exactly the way you
> describe for resident ratios).


Thanks for the detailed comments.

I agree that improving the default proactive/async reclaim behavior can
be useful, and I also agree that tiered memcg counters/limits would be
useful. I do not see source=nodes as a replacement for those directions.
They solve different parts of the problem: tiered counters/limits provide
accounting and policy targets, while source=nodes is only an actuator for
proactive reclaim.

So I think these directions are compatible. A better default reclaim
policy or tiered memcg limits can improve kernel-driven behavior, while
source=nodes gives userspace an explicit way to apply reclaim pressure
to a selected resident source.

>
>> I am not sure whether changing the default whole-cgroup reclaim behavior
>> in this direction could affect existing userspace dependencies. In the
>> old nodes= discussion, Mina mentioned that Meta's reclaim stack relied on
>> memory.reclaim triggering demotion [1].
>>
> Yes and on its surface this is something I could see Meta using, however
> I question whether we're simply trying to find a convenient way around
> fixing reclaim to do the right thing (not invert the LRU, apply per-tier
> memcg limits, etc).


That is fair, and I do not intend this to avoid improving reclaim or
adding better tier-aware memcg accounting. A better memory.reclaim
algorithm would also make source=nodes more useful, because source=nodes
still uses the existing reclaim path after selecting the resident source.
The goal here is narrower: expose a source-scoped proactive reclaim
actuator while keeping the kernel's reclaim policy in control. The old
nodes= discussion had ABI problems, but it also showed that a
nodemask-like source selector is a useful primitive for finer-grained
proactive reclaim control [1].

>
>> I also do not intend source= to lock in current reclaim implementation
>> details. It should stay consistent with the current design: source= only
>> selects the resident source to which reclaim pressure is applied, while
>> the kernel remains free to change the reclaim policy.
>>
> Well, sort of, you get exposed to the implementation details by having
> to negotiate what is considered progress under different scenarios.
>
> Lets take one example - what should happen when:
>   - 2 node system, node0=DRAM, node1=CXL
>   - zswap is configured
>   - echo 1G source=nodelist:1 > memory.reclaim
>   - node 1 is pressured, zsmalloc falls back to node0 to allocate
>
> Should that be considered progress? We reclaimed from node1, but
> increased pressure on node0 - which might have kicked kswapd or memcg
> accounting to demote memory from node0 to node1.
>
> Should zswap also take that nodelist as a constraint?


This is a good example of why source=nodes should not be described as a
one-shot net footprint guarantee. Assuming source=nodes:1, the request
applies reclaim pressure to memcg memory resident on node1. That may
free some space on node1 in the short term, which can provide room for a
later node0-to-node1 demotion step. If zswap allocation, kswapd, or memcg
reclaim later moves pressure back across tiers and node1 usage rises
again, that is part of the dynamic reclaim/tiering behavior.

So userspace cannot rely on one write to memory.reclaim to produce a
final per-node distribution. The intended usage is a feedback loop: the
controller observes the memcg's resident distribution, chooses the source
nodes it wants to relieve, applies source-scoped reclaim pressure,
observes the new distribution, and iterates.

I do not think this patch should make source=nodes constrain zswap pool
allocations. That would be a different and much stronger semantic. The
current intent is only to constrain the resident source from which memcg
reclaim applies pressure, while completion accounting remains the
existing memory.reclaim accounting.

>
> At the very least i think you need to add details in your cover that
> demonstrates the process of doing something like per-node resident
> ratios, and show that it works as you intend.
Agreed. I will update the cover letter to make this model clearer. I
will also make clear that source=nodes is not a final net per-node
footprint guarantee and does not change memory.reclaim completion
accounting.

[1] https://lkml.org/lkml/2022/12/14/194

Thanks,
Zhe

