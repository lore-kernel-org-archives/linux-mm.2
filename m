Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55B05606A884
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=o3h8POg/
Received: by kanga.kvack.org (Postfix)
	id 75F316B05B9; Thu, 12 Nov 2026 04:41:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 736A36B05BA; Thu, 12 Nov 2026 04:41:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 675686B05BB; Thu, 12 Nov 2026 04:41:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4277B6B05B9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:41:17 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C0DAF1C3D21
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:41:16 +0000 (UTC)
X-FDA: 85425973752.17.1F50592
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1B9F2140003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:41:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="o3h8POg/";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794476475;
	b=SzLHYvS0OwLoTyI9DhQ6i1N74CuzydjTr5FO2NbZboJJcT9YPpwDjtcjE3Kq16jKiPy8g7
	DVtSdYbsseifJQF1qMCc3YQS/PKXJgO2wmX8hHnVUYlNVk+jk2SGB2XsfyOmUa1SqXIbBs
	Ho/vr44gMIPpcPKfc5y+A8/1c3J4taY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794476475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9+MlPPeoxwJgyAMbPiBz4BUsxCi6G4HJntT/EUUnkYY=;
	b=bOaA5jrw0JAnjKHmHjRnXjk0FUaAvfiZRwZgMLWFYsyNoBCu4m3oXXEtKD047gUoVwwQfW
	dTsssctYHmdO4hN3ceEVOaKv5SDOS+i/fmVRzyLksQWun7YCWxmwmTQi+xJrFMG7VxmcfC
	x0888KnQyw7aIfeCFSpRdVF+jz1TMCU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="o3h8POg/";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794476468; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=9+MlPPeoxwJgyAMbPiBz4BUsxCi6G4HJntT/EUUnkYY=;
 b=o3h8POg/NVmQZLZyisMfzgh/W0F4G+EBpzD4RxLoJ9ThU+MIc0cOnc/m+TRWgZ/FAfiTO3
 kuO31vVyrrxST+HqMNe3uecKINEcePm5bSAMv+eaU1KJOgoIqP8KbHkBr7o/TE8WrOlECF
 QOkI8k/0lrxfo9hCzX3qn6kCvUz6A1g2erMA+RZtyHaBgwCldw9Eugx9eT/YKMKU74nZ3l
 VAYzw77LpppkiK3FV/Unevu4mR8soocu3KrBZvhWoTHJLwZaIosLeLbJuxtd55BBQ9bCLS
 9DIt+RWQ/Z5XR2QLAtIqg0IK0IUWv7e8yz/rS2eBXa9E1EoLLpqatIr47irWwA==
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Thu, 12 Nov 2026 17:40:43 +0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26af589b2+49a342+kvack.org+lizhe.67@bytedance.com>
Subject: Re: [RFC 0/2] mm: add source selectors to memory.reclaim
User-Agent: Mozilla Thunderbird
To: "Joshua Hahn" <joshua.hahnjy@gmail.com>
References: <20261111181714.1463827-1-joshua.hahnjy@gmail.com>
Content-Type: multipart/alternative;
 boundary=171c784412fdc7e4596621321c272c2a957c8b7e6c9263002575ed16851a
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>, 
	<ziy@nvidia.com>, <rakie.kim@sk.com>, <ying.huang@linux.alibaba.com>, 
	<ljs@kernel.org>, <mhocko@suse.com>, <muchun.song@linux.dev>, 
	<roman.gushchin@linux.dev>, <shakeel.butt@linux.dev>, 
	<weixugc@google.com>, <cgroups@vger.kernel.org>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, "Johannes Weiner" <hannes@cmpxchg.org>
Message-Id: <9324843a-3242-461d-a145-a5f21ea29b10@bytedance.com>
In-Reply-To: <20261111181714.1463827-1-joshua.hahnjy@gmail.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: 1B9F2140003
X-Rspamd-Server: rspam12
X-Stat-Signature: t6t876tp6ceksgeq6ghftfsui9ocfpbq
X-Rspam-User:
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794476473-325188
X-HE-Meta: U2FsdGVkX1+XBYib7WbUAk3+4o8ORdYdwqgs9ogDBQunqzmG68kAU6JZfhZnNDnIPoi25oIL0H6+7wzQ00AuKpJALmL0am7t2WwXBidTHFI0fapLvbX9GfhPeD8DxYzPtchANGjXaAWHTQW5SYgrFEi5bot+gY3A+WNXVRDO4xtDKot1DtPAmUki8f8pj4oSbT0P51lOThKDZQP2eOQjfWvpmeN8z1fYbWPWVqR61ge/egUV3a6C6FVBqsHg1gdDe9rrNEiY0dSDXW4tD1o5FawbDQJ6cyKqLtif7hm2o4Ing8l8a7YEj+r1vXUaKT6nHpPFu6GOi+MOV11Nmu4tilfZeO6VrXBMJ2kGUkKdhkAbgK7oURH4MvG4Vf4QmGPOVGpwxqRTdRHecr+FljO2nlFqzgNwzPkxAqYztCl0SRD6M8MIm3CwicZnTzhdxt7K5CLoSoot5zKIILpxN5M05VONqHxva6oP9AzTDMvn4QJ+HOwD+Mi2GnHzghX4RlzhadYc4wJedrOyuAF54mzCFCfvHMJ8fNqEpkrKIc5YU2Dmem81F5ecAuz3L6Rkr2s7EwnniKeA/8lJXHztgNMQGpsjeFOqXjn2cZVeM0Dxsh3oQ604ce1GWC0Y/JhYFp5jh7V1A7Gs0oQSIf4plMOPS1jKOtefgAm5BLiSNvTWGDVh0+od+108dFGyxsyp3qG9kdtkVFJiGvci+QR4n5wOOvBa5nbTC6fKIeTAfnFcQ7zweA4gj6rAtJfhSqlWOFrJ5Di+hKNHGgc3qg7dx7d8jI+yjpGC76NaB3dlSeyxTFF13Gtew/GVcl6w/niBGUINn8AP+bZ7YhOD18QluYh7yvMS7fEjnSiCrZQNPptqAC9WZLzweIGOcRF68R9bynSSnjXX4t4NMKwWMnQ5skkrSF+A4q3MhKC8cDIWB13j9P6voy25OBX2ssGlOcacTchWqpKiu7rKFxHM0YBHdMz
 I0Yz0z00
 qJHWU41cjLQ5KDYUuuxTzLlsb1j9p5+JRoD+L2GE8FsgQawbnkjZN01Cii9JIgCSlOgybsbKGKm+0OL5s9sw/hjR6CbruqNEX0cmzffFmxRQ2DrOj5pKQujwZKE9iKJ1U0xwWrhKtGdvCUZ8/R44LDCxproFGIxoxGamP3etTd+WxPonl9ESiXiQH1mWyqGtORO9LlWCxpes7Nta+9grBamSTSBCxjfWrUIyAwpkqOnoxwS8MPZf1i/qupc2f7kIpa/ZCyUNDgt+J8qlYMOu7ZB5h0eJMnq61cOARbtLirjCWCmvVnta2ykgPKg2Y3PiVuMi/iFPuVZOUh4CYCcfdoEMJCU8Mfc5t4XEKKnsb31/FCeON0WblZMG5VlN8jQZSZ9kl6ltTIkmuMqExoVsPTt1ML5AfoYH5Rn5zPGwaqrGPQTGaZ2ICAV34/7iKB9Wq0FGHANLikUA1SgZ8UYBrfEMyCAx7nJ8t5VtPsMdlGWVWEUARAqjnvhj69+lGincq8svx283pr/pnHFt2hPv9UEYdatGnoBe3N4UGsnhjqLU1eHqHeIM1zZGSbyWezNmpxvFsA9ViTT9Uv9lJ7DyQlIushIfCc4kHPS3XX2peEQO1m9y4bxIld7+KoajIo4Z0+9utWbPF2hhk078TgXLbzGj4UGWRGyBFn9vqq3AmabC+9fLsCWUS2HBqpGoyowjjyvlNOBCYf8CjKjOt7IbP9026k+8RcHD1EFEuZo15zNvV+TOUxJ0QMsem58bXn1YdgT2v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--171c784412fdc7e4596621321c272c2a957c8b7e6c9263002575ed16851a
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8

On 11/12/26 2:17 AM, Joshua Hahn wrote:
> On Mon, 19 Oct 2026 22:13:59 +0800 "Li Zhe"<lizhe.67@bytedance.com> wrote:
>
>> memory.reclaim is a useful proactive reclaim interface for memcgs, but
>> tiered memory makes "reclaim N bytes from this memcg" underspecified for
>> userspace controllers that manage memory placement across tiers. The
>> kernel's reclaim policy is aging-based, and on tiered systems aging may
>> demote folios before they are eventually evicted. Without a way to
>> declare where reclaim pressure should start, userspace can only reclaim
>> from the memcg as a whole and observe one aggregate progress value.
> Hi Zhe,
>
> I hope you have been doing well. I'm circling back to this discussion
> to see if there have been any updates since we last spoke about this.


Hi Joshua, thanks for following up.

I sent a v2 on Nov 2:

https://lore.kernel.org/all/20261102070440.16262-1-lizhe.67@bytedance.com/

>
> I'm wondering how feasible it would be to enforce some kind of placement
> decision from userspace with this new tool. That is, I think I would be
> interested to see if this solution was enough to grant fair placement
> of memroy across tiers within a memcg.
>
> Were you able to run tests to demonstrate how effective this was at
> managing placement decisions for memory?


v2 includes some basic placement-control tests on a CXL machine. The
tests use fio and stress-ng workloads, compare source=nodes against a
plain memory.reclaim baseline, and include a disturbed case with
external reclaim and demotion activity.

Could you take a look and let me know whether these tests are enough to
show the placement-control problem, or whether you think the coverage
should be changed or extended?

>
> Of course, I think we should answer the ABI questions below. Maybe some
> of the memcg folks could chime in a bit about what kinds of interfaces
> they would like to see.


Yes, agreed. Thanks for Cc-ing Johannes. I would appreciate feedback
from the memcg side on whether the v2 ABI shape is narrow enough.

>
> To start, I'll reiterate what I've said in the previous response, I
> think we should keep this a node extension until we can demonstrate a
> scenario where there needs to be tier-awareness (to be honest, I don't
> think there is one).


Agreed. v2 drops the tier-aware selector and keeps only source=nodes. I
also think the node interface is sufficient for now.

For more background on the target use case, I shared the broader
scenario in a discussion with Gregory:

https://lore.kernel.org/all/67fcd8db-269d-43f1-aea2-8c41165747d0@bytedance.com/

In short, the target is mixed DRAM/CXL machines running multiple
services in different cgroups. The goal is to let each workload stay
near its own performance/cost balance point by adjusting its DRAM/CXL
resident distribution over time.

Thanks,
Zhe

>
> Cc-ing Johannes who is a memcg maintainer but was not CCed in the
> original series:
> Cc: Johannes Weiner<hannes@cmpxchg.org>
>
> Thanks, have a great day!
> Joshua
>
>> There is prior history here [1]. The old nodes= proposal tried to let
>> memory.reclaim scan selected NUMA nodes, but the discussion left several
>> ABI questions unresolved:
>>
>> - nodes= did not clearly say whether the mask was a source selector, a
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
>> This series takes a narrower approach. It adds a typed source= key which
>> declares only the source on which the existing memory.reclaim aging
>> pipeline should be applied. It is not a demotion target selector, not a
>> demotion-only goal, not an eviction-only goal, and not a change to the
>> existing completion accounting. Leaving source unspecified preserves the
>> existing memory.reclaim behavior.
>>
>> In that sense, this series extends node-scoped reclaim pressure to the
>> memcg memory.reclaim interface. The existing node memory_reclaim
>> interface can apply pressure to a node, but it is not scoped to a
>> particular memcg. This series lets userspace apply the same kind of
>> source-scoped pressure to a cgroup's resident memory on selected nodes
>> or tiers, while still using the normal memcg reclaim path.
>>
>> The main benefit of this series is to give userspace a steering knob
>> for per-node and per-tier memory placement control. A tiering controller
>> can observe the resident memory distribution across nodes or memory
>> tiers, and then apply reclaim pressure to the source that should be
>> relieved. For example, it can apply pressure to top-tier nodes so that,
>> under the existing tiering policy, cold folios can be aged and usually
>> demoted to lower tiers, or reclaim from a terminal tier when it needs
>> actual charge reduction.
>>
>> The existing memory.reclaim interface cannot express this. It applies
>> pressure to the memcg as a whole, so on a multi-tier system the kernel
>> may make progress in a tier different from the one userspace is trying
>> to control. That makes feedback control of tier ratios ineffective: the
>> controller can observe that a specific tier is over its desired resident
>> footprint, but it cannot direct the next reclaim request to that tier.
>>
>> Patch 1 adds source=nodes:<nodelist>, which is the basic source
>> selector. Patch 2 adds source=tier:<N>, where N is the memory_tierN id
>> exposed by /sys/devices/virtual/memory_tiering/. The tier selector is
>> only a convenience layer over the same source semantics: it resolves the
>> current tier nodelist at write time and then uses the same source-scoped
>> reclaim path as source=nodes:<nodelist>.
>>
>> The remaining issues from the old discussion are intentionally left out
>> of this series. If userspace needs to control demotion targets, that
>> should be a separate target/demotion-policy ABI rather than folded into
>> source=. If userspace needs a strict "bytes actually uncharged"
>> completion mode, that should be discussed as a separate accounting or
>> goal extension because it would change the observable meaning of
>> memory.reclaim progress. This series only adds source selection for the
>> existing reclaim policy.
>>
>> References:
>> [1]https://lore.kernel.org/all/Y5bsmpCyeryu3Zz1@dhcp22.suse.cz/
>>
>> Li Zhe (2):
>>    mm: add source selector to memory.reclaim
>>    mm: add tier source selector to memory.reclaim
>>
>>   Documentation/admin-guide/cgroup-v2.rst | 29 +++++++++++
>>   include/linux/memory-tiers.h            |  6 +++
>>   mm/internal.h                           |  3 +-
>>   mm/memcontrol-v1.c                      |  6 ++-
>>   mm/memcontrol.c                         | 11 +++--
>>   mm/memory-tiers.c                       | 24 ++++++++++
>>   mm/vmscan.c                             | 64 +++++++++++++++++++++++--
>>   7 files changed, 133 insertions(+), 10 deletions(-)
>>
>> -- 
>> 2.20.1
--171c784412fdc7e4596621321c272c2a957c8b7e6c9263002575ed16851a
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset=UTF-8

<!DOCTYPE html><html><head>
    <meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3DUTF-8=
"/>
  </head>
  <body>
    <p><br/>
    </p>
    <div class=3D"moz-cite-prefix">On 11/12/26 2:17 AM, Joshua Hahn wrote:<=
br/>
    </div>
    <blockquote type=3D"cite" cite=3D"mid:20261111181714.1463827-1-joshua.h=
ahnjy@gmail.com"><div id=3D"lark-mail-quote-2ccaf1239010c17f85ce9a43688b451=
1">
      <pre wrap=3D"" class=3D"moz-quote-pre">On Mon, 19 Oct 2026 22:13:59 +=
0800 &#34;Li Zhe&#34; <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:liz=
he.67@bytedance.com">&lt;lizhe.67@bytedance.com&gt;</a> wrote:

</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"" class=3D"moz-quote-pre">memory.reclaim is a useful p=
roactive reclaim interface for memcgs, but
tiered memory makes &#34;reclaim N bytes from this memcg&#34; underspecifie=
d for
userspace controllers that manage memory placement across tiers. The
kernel&#39;s reclaim policy is aging-based, and on tiered systems aging may
demote folios before they are eventually evicted. Without a way to
declare where reclaim pressure should start, userspace can only reclaim
from the memcg as a whole and observe one aggregate progress value.
</pre>
      </blockquote>
      <pre wrap=3D"" class=3D"moz-quote-pre">Hi Zhe,

I hope you have been doing well. I&#39;m circling back to this discussion
to see if there have been any updates since we last spoke about this.</pre>
    </div></blockquote>
    <p><br/>
    </p>
    <p>Hi=C2=A0<span style=3D"white-space: pre-wrap">Joshua, </span>thanks =
for
      following up.<br/>
      <br/>
      I sent a v2 on Nov 2:<br/>
      <br/>
<a class=3D"moz-txt-link-freetext" href=3D"https://lore.kernel.org/all/2026=
1102070440.16262-1-lizhe.67@bytedance.com/">https://lore.kernel.org/all/202=
61102070440.16262-1-lizhe.67@bytedance.com/</a></p>
    <blockquote type=3D"cite" cite=3D"mid:20261111181714.1463827-1-joshua.h=
ahnjy@gmail.com">
      <pre wrap=3D"" class=3D"moz-quote-pre">

I&#39;m wondering how feasible it would be to enforce some kind of placemen=
t
decision from userspace with this new tool. That is, I think I would be
interested to see if this solution was enough to grant fair placement
of memroy across tiers within a memcg.

Were you able to run tests to demonstrate how effective this was at
managing placement decisions for memory?</pre>
    </blockquote>
    <p><br/>
    </p>
    <p>v2 includes some basic placement-control tests on a CXL machine.
      The<br/>
      tests use fio and stress-ng workloads, compare source=3Dnodes
      against a<br/>
      plain memory.reclaim baseline, and include a disturbed case with<br/>
      external reclaim and demotion activity.<br/>
      <br/>
      Could you take a look and let me know whether these tests are
      enough to<br/>
      show the placement-control problem, or whether you think the
      coverage<br/>
      should be changed or extended?<br/>
      <br/>
    </p>
    <blockquote type=3D"cite" cite=3D"mid:20261111181714.1463827-1-joshua.h=
ahnjy@gmail.com">
      <pre wrap=3D"" class=3D"moz-quote-pre">

Of course, I think we should answer the ABI questions below. Maybe some
of the memcg folks could chime in a bit about what kinds of interfaces
they would like to see.</pre>
    </blockquote>
    <p><br/>
    </p>
    <p>Yes, agreed. Thanks for Cc-ing Johannes. I would appreciate
      feedback<br/>
      from the memcg side on whether the v2 ABI shape is narrow enough.<br/=
>
      <br/>
    </p>
    <blockquote type=3D"cite" cite=3D"mid:20261111181714.1463827-1-joshua.h=
ahnjy@gmail.com">
      <pre wrap=3D"" class=3D"moz-quote-pre">

To start, I&#39;ll reiterate what I&#39;ve said in the previous response, I
think we should keep this a node extension until we can demonstrate a
scenario where there needs to be tier-awareness (to be honest, I don&#39;t
think there is one).</pre>
    </blockquote>
    <p><br/>
    </p>
    <p>Agreed. v2 drops the tier-aware selector and keeps only
      source=3Dnodes. I<br/>
      also think the node interface is sufficient for now.<br/>
      <br/>
      For more background on the target use case, I shared the broader<br/>
      scenario in a discussion with Gregory:<br/>
      <br/>
<a class=3D"moz-txt-link-freetext" href=3D"https://lore.kernel.org/all/67fc=
d8db-269d-43f1-aea2-8c41165747d0@bytedance.com/">https://lore.kernel.org/al=
l/67fcd8db-269d-43f1-aea2-8c41165747d0@bytedance.com/</a><br/>
      <br/>
      In short, the target is mixed DRAM/CXL machines running multiple<br/>
      services in different cgroups. The goal is to let each workload
      stay<br/>
      near its own performance/cost balance point by adjusting its
      DRAM/CXL<br/>
      resident distribution over time.<br/>
      <br/>
      Thanks,<br/>
      Zhe<br/>
      <br/>
    </p>
    <blockquote type=3D"cite" cite=3D"mid:20261111181714.1463827-1-joshua.h=
ahnjy@gmail.com">
      <pre wrap=3D"" class=3D"moz-quote-pre">

Cc-ing Johannes who is a memcg maintainer but was not CCed in the
original series:
Cc: Johannes Weiner <a class=3D"moz-txt-link-rfc2396E" href=3D"mailto:hanne=
s@cmpxchg.org">&lt;hannes@cmpxchg.org&gt;</a>

Thanks, have a great day!
Joshua

</pre>
      <blockquote type=3D"cite">
        <pre wrap=3D"" class=3D"moz-quote-pre">There is prior history here =
[1]. The old nodes=3D proposal tried to let
memory.reclaim scan selected NUMA nodes, but the discussion left several
ABI questions unresolved:

- nodes=3D did not clearly say whether the mask was a source selector, a
  reclaim domain, or a demotion-target constraint.
- The implementation did not apply the mask to the whole reclaim path,
  so demotion could allocate outside the mask. If userspace interpreted
  the mask as a domain or target constraint, the ABI did not provide
  that.
- Selecting top-tier nodes could become an implicit way to request
  demotion without uncharge. That would make userspace depend on a
  particular reclaim policy and could make future policy changes hard.
- The separate completion-accounting question remained: demotion can
  count as reclaim progress even though memory.current is not reduced.

This series takes a narrower approach. It adds a typed source=3D key which
declares only the source on which the existing memory.reclaim aging
pipeline should be applied. It is not a demotion target selector, not a
demotion-only goal, not an eviction-only goal, and not a change to the
existing completion accounting. Leaving source unspecified preserves the
existing memory.reclaim behavior.

In that sense, this series extends node-scoped reclaim pressure to the
memcg memory.reclaim interface. The existing node memory_reclaim
interface can apply pressure to a node, but it is not scoped to a
particular memcg. This series lets userspace apply the same kind of
source-scoped pressure to a cgroup&#39;s resident memory on selected nodes
or tiers, while still using the normal memcg reclaim path.

The main benefit of this series is to give userspace a steering knob
for per-node and per-tier memory placement control. A tiering controller
can observe the resident memory distribution across nodes or memory
tiers, and then apply reclaim pressure to the source that should be
relieved. For example, it can apply pressure to top-tier nodes so that,
under the existing tiering policy, cold folios can be aged and usually
demoted to lower tiers, or reclaim from a terminal tier when it needs
actual charge reduction.

The existing memory.reclaim interface cannot express this. It applies
pressure to the memcg as a whole, so on a multi-tier system the kernel
may make progress in a tier different from the one userspace is trying
to control. That makes feedback control of tier ratios ineffective: the
controller can observe that a specific tier is over its desired resident
footprint, but it cannot direct the next reclaim request to that tier.

Patch 1 adds source=3Dnodes:&lt;nodelist&gt;, which is the basic source
selector. Patch 2 adds source=3Dtier:&lt;N&gt;, where N is the memory_tierN=
 id
exposed by /sys/devices/virtual/memory_tiering/. The tier selector is
only a convenience layer over the same source semantics: it resolves the
current tier nodelist at write time and then uses the same source-scoped
reclaim path as source=3Dnodes:&lt;nodelist&gt;.

The remaining issues from the old discussion are intentionally left out
of this series. If userspace needs to control demotion targets, that
should be a separate target/demotion-policy ABI rather than folded into
source=3D. If userspace needs a strict &#34;bytes actually uncharged&#34;
completion mode, that should be discussed as a separate accounting or
goal extension because it would change the observable meaning of
memory.reclaim progress. This series only adds source selection for the
existing reclaim policy.

References:
[1] <a class=3D"moz-txt-link-freetext" href=3D"https://lore.kernel.org/all/=
Y5bsmpCyeryu3Zz1@dhcp22.suse.cz/">https://lore.kernel.org/all/Y5bsmpCyeryu3=
Zz1@dhcp22.suse.cz/</a>

Li Zhe (2):
  mm: add source selector to memory.reclaim
  mm: add tier source selector to memory.reclaim

 Documentation/admin-guide/cgroup-v2.rst | 29 +++++++++++
 include/linux/memory-tiers.h            |  6 +++
 mm/internal.h                           |  3 +-
 mm/memcontrol-v1.c                      |  6 ++-
 mm/memcontrol.c                         | 11 +++--
 mm/memory-tiers.c                       | 24 ++++++++++
 mm/vmscan.c                             | 64 +++++++++++++++++++++++--
 7 files changed, 133 insertions(+), 10 deletions(-)

--=20
2.20.1
</pre>
      </blockquote>
    </blockquote>
 =20
</body></html>
--171c784412fdc7e4596621321c272c2a957c8b7e6c9263002575ed16851a--

