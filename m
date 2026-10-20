Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DD20606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 09:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=CbcdiNbd
Received: by kanga.kvack.org (Postfix)
	id 8FC2A6B014A; Tue, 20 Oct 2026 05:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D2AA6B014B; Tue, 20 Oct 2026 05:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E9E06B014C; Tue, 20 Oct 2026 05:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56FB56B014A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:07:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BB2A780911
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:07:10 +0000 (UTC)
X-FDA: 85342425420.26.37343EC
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf13.hostedemail.com (Postfix) with ESMTP id BB65A2000E
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:07:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=CbcdiNbd;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792487228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=17hQliTTVycNMjFjUeYlptDj5DXt5fa/p+ydi6udKSU=;
	b=FuoWApREjlaF6gpXg2jhBSAxnCXtdshlnxiXXlQJqcFgh4NzFo9vsRm1mbNKBj3xNS0iwZ
	awdZCneTVGngfmCPKfgPKfCGOv1s6LQem3IuAJX9S0pf3VYadgBpVf3Xq3tW5UU4aTNZXn
	xR7y15Fr0kBz35dvu+lfM4iUZENcAtI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=CbcdiNbd;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792487228;
	b=UvBatk7owDD7pIMa5l7m0Xmi1Ei0N5OCr0w88SiTB6wX855caJBvSDxRAlroSPqLJCln0T
	utYn03jroB9iVP8SLTKmb2IHpLxYsY/AWjgA1t+iwZR4GlQlwS5sqIhSXHdO5MyILdyOvW
	eUi3c/VhgmQP6onkPdbFqgyGuJu54vM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792487215; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=17hQliTTVycNMjFjUeYlptDj5DXt5fa/p+ydi6udKSU=;
 b=CbcdiNbdjdxNlHE2TRUMEGqzC5RJRVr30/A6wobowz6vKXEVnXa4SmsZ8TWT1Wsl3vzZop
 bXko9wLjVyhUlGJlq8uS9of643SAwcApwV/2kUYaSCFAjaVIAK9roqwziVo4VOYDWJbBZv
 tY1Ypng3AsUEYoRzV1GI/Um7ztcVpZ/LmNAyJuLiUaF4GIPKYs+vKXo+KeaQC3UQGP+iXY
 FIIYKUpSeGNL1CSBMSPJ1BWpZoRZCfcwlY2mSLZMjy/J0hvq1BnIXnKnMMd8vUcreHECMT
 OIQKkUXy5DuqQFb45s5m4PjKlvGyW9LAVgtscobAiBAT+1h8Y3Kti+YratReDw==
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>, 
	<ziy@nvidia.com>, <rakie.kim@sk.com>, <ying.huang@linux.alibaba.com>, 
	<ljs@kernel.org>, <mhocko@suse.com>, <muchun.song@linux.dev>, 
	<roman.gushchin@linux.dev>, <shakeel.butt@linux.dev>, 
	<weixugc@google.com>, <cgroups@vger.kernel.org>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Tue, 20 Oct 2026 17:06:28 +0800
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26ad72f2d+5af98d+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Subject: Re: [RFC 0/2] mm: add source selectors to memory.reclaim
Message-Id: <6b0a2dba-6096-432d-bc1a-251343dd1e74@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Joshua Hahn" <joshua.hahnjy@gmail.com>
In-Reply-To: <20261019152148.3330024-1-joshua.hahnjy@gmail.com>
References: <20261019152148.3330024-1-joshua.hahnjy@gmail.com>
User-Agent: Mozilla Thunderbird
X-Rspamd-Queue-Id: BB65A2000E
X-Stat-Signature: xnzwyduw4o89p5ohx8qm9jiph7yrtzyp
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792487227-284784
X-HE-Meta: U2FsdGVkX19tsfPznz2O5UcSXcQvUvRwCRd3eOVqnw+DqSVN5hyRDv9a9xtTUe/h2bKhGdp6yqxDvQd45Qg4nh9y9czAVBZV6YXlFq7h3BPLMf4VGWOy206i5OwqOvDXuDkRTZsTiHYOZsJjU05ofU9ZmVmqzkQuoFJw39xLoXHp+FPRWD6c5DWzQYHTPaherv3FKSpvWYCFXXhfdXaI4x8lJF3ypS6VCkfPq4ZJG2nwNa+gAKqcYGF83Quylr/dE5ue+PlzBoH4E6dEtYlPnqSFlMZgjGDn1qc2SA02oc3+cl5okSuSzJyLBZx/IF6oRirnD5NsnRl74NgNtfcOKvOY/V+pal8DTwrgUcWU+5VYghHwbFamA7g6cSralFwpd25LGgtZOhjnfpPYU9A61ubqQktr0NK1u47MrAhNXdZ7+somVq9atysWCRKWesW0mhuphi0Nic/pCE59IgjwegDM/nJc8QUXWvA+u+gHuGoMymWjOrrpwFJaDT1XE3He+H8oL0EbU4wc1G6tGGMdFVSa6mv55n8Z4eDfDA9kn7NtSSi1beog6LXGS5hvH7xoUlDeMWii/2SR85d7Fdxk4K+HVB8Y6S0uV9W4h3kQvVm1Lu+4k9DaDiebIZBAeRYSS+mHHo/SaRW2crs7oN/gRhWcnkgvnRzePaQzMe22Rsjx/Raf72RERKpkl1rGYFbaZIis1huq4yOmxgtN6E6pyZigeiXQVbuVoSZEAlwy10nQ2YZxxjYLBpNCe9kTSw9jHXjSbbaTmw7dsyvR8o+1HyK0sJRK993Kqhg3n0YE78VgIHNvJtawDrYTDtEx9eyeE/nUT4C9zscP5BVAthQfBdveyIJCfvTBMOa1w8vh7UheCdX1XVxcbGVX/8NzPEkPCbf4wwdtTMUMajUxoYiXrffwUr5XJEkXhOunGCRFNWpC3y/jfW0ML3ENrw9CXLLetu3fo8X+rsCIQazyvIU
 BcbJlhme
 /TqLbN4VxXV6mNr6PbiWjy4h8QkqowGKMoHwVMm/lWWolXS1ACEQG9DbsdrlHUkbD6UFhO6MfacURaO/dQXUssEW9XHENwKHKOEs0GBcgYWX1L4nnC3eWAIktC+L9qQ9olVD7y6DnC0zVDAzxQyWos1j2Dntqx0Sipn7fxsVEMJBGLYk9PbleCT8UzDCAVjDtk0d47LbiajB6xta5zxyTvPn+Dn3b/4WSMqKbZRrF19tRM6HKlJQmlA7eOiF2J6PZDWQPinN6elOgbH65AmeoUfKvcMqjzZSG4t7/rkEzmti9+W15A3P3etVh8IlHtosXxJv4Q9TRDiAdrmJN9Cuom3LSmSSRlondmbCWsQPcAs7mynZptHD+ok2xrS/F+WV0PFRdOl9DtOyhDGE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/19/26 11:21 PM, Joshua Hahn wrote:
> On Mon, 19 Oct 2026 22:13:59 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:
>
>> memory.reclaim is a useful proactive reclaim interface for memcgs, but
>> tiered memory makes "reclaim N bytes from this memcg" underspecified for
>> userspace controllers that manage memory placement across tiers. The
>> kernel's reclaim policy is aging-based, and on tiered systems aging may
>> demote folios before they are eventually evicted. Without a way to
>> declare where reclaim pressure should start, userspace can only reclaim
>> from the memcg as a whole and observe one aggregate progress value.
> Hi Li,
>
> Thank you for working on this patch. I think it's quite interesting.
> I have many comments about implementation detials but for now let's
> discuss the direction of this series first.
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
>> This series takes a narrower approach.
> I think this is the way to go.


Thanks for taking a look.

>
>> It adds a typed source= key which
>> declares only the source on which the existing memory.reclaim aging
>> pipeline should be applied.
> Calling it an "aging pipeline" is a big confusing to me. Maybe just call
> it eviction targets or reclaim targets?

Thanks. By "aging pipeline" I meant the combined reclaim behavior that
may demote some folios and evict others, depending on the existing
reclaim policy. But this wording is confusing here. I will use "reclaim
targets" in v2.
>
>> It is not a demotion target selector, not a
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
> To me I think the other interesting aspect is being able to evict memory
> from lower tiers out to swap so that toptier always has room for
> demotions, preventing swapouts from higher tiers. In fact I think for
> my interests this is the more important use case.


Thanks for pointing this out. This is indeed another important use
case. I will add this use case to the cover letter in v2.

>
>> The existing memory.reclaim interface cannot express this. It applies
>> pressure to the memcg as a whole, so on a multi-tier system the kernel
>> may make progress in a tier different from the one userspace is trying
>> to control. That makes feedback control of tier ratios ineffective: the
>> controller can observe that a specific tier is over its desired resident
>> footprint, but it cannot direct the next reclaim request to that tier.
> This part is confusing to me. The kernel curently doesn't observe
> per-tier-memcg memory footprint and try to manage it, does it?
> ( that is what I'm trying to solve currently in my tiered memcg series ; -)
>    but as it stands right now, I don't think there is any feedback loop )


Right, I did not mean that the kernel has such a feedback loop today.
The feedback loop I had in mind is a userspace controller loop: userspace
observes the memcg's resident distribution, for example from per-node
memcg stats, maps nodes to tiers, and then issues memory.reclaim against
the source it wants to relieve.

The wording is confusing because it can sound like an existing kernel
policy. I will reword this in v2.

I have also looked at your tiered memcg series. If it is merged, I think
it will be very useful for tiering use cases. I hope that work can move
forward as well.

>
>> Patch 1 adds source=nodes:<nodelist>, which is the basic source
>> selector.
> In general I agree with Lorenzo, it took me a second to realize that the
> bulk of this series is just adding a nodemask to
> try_to_free_mem_cgroup_pages. It might be helpful to just call it
> "reclaim" instead of calling it an aging pipeline.


Agreed. I will simplify both the cover letter and the documentation in v2.

>
>> Patch 2 adds source=tier:<N>, where N is the memory_tierN id
>> exposed by /sys/devices/virtual/memory_tiering/. The tier selector is
>> only a convenience layer over the same source semantics: it resolves the
>> current tier nodelist at write time and then uses the same source-scoped
>> reclaim path as source=nodes:<nodelist>.
> Personally I think that it makes more sense to just start with a
> node-based reclaim interface, and then extending it to tiers. It seems
> like the tier usecase is entirely doable with just a nodemask interface.


That is reasonable. source=tier is only a convenience wrapper around the
same node mask semantics. It is not required for the core ABI.

I can drop patch 2 in v2 and start with source=nodes only.

>
> And in this case, since we're just selecting the sources of reclaim,
> tiers don't really matter, right? That is, we don't care if the memory
> gets demoted or swapped out, we just care that the footprint for the
> tier memcg goes down.


Yes, that matches the intended semantics. source= selects the resident
source to apply reclaim pressure to. It does not choose whether progress
comes from demotion or eviction.

So for source=tier, the tier only provides a convenient way to resolve a
set of source nodes. The actual reclaim semantics are still the same as
source=nodes.

>
>> The remaining issues from the old discussion are intentionally left out
>> of this series. If userspace needs to control demotion targets, that
>> should be a separate target/demotion-policy ABI rather than folded into
>> source=. If userspace needs a strict "bytes actually uncharged"
>> completion mode, that should be discussed as a separate accounting or
>> goal extension because it would change the observable meaning of
>> memory.reclaim progress. This series only adds source selection for the
>> existing reclaim policy.
> 100% agree.
>
> Thanks Li, I hope you have a great day!
> Joshua


Thanks for taking a look.

Thanks,
Zhe

>   
>> References:
>> [1] https://lore.kernel.org/all/Y5bsmpCyeryu3Zz1@dhcp22.suse.cz/
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

