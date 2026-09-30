Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F2ABCA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 14:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BAC76B008A; Wed, 30 Sep 2026 10:02:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76BEC6B008C; Wed, 30 Sep 2026 10:02:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681796B0092; Wed, 30 Sep 2026 10:02:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 44A746B008A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:02:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B1C4CC07AF
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:02:55 +0000 (UTC)
X-FDA: 85270594710.11.6AD5A2E
Received: from va-2-115.ptr.blmpb.com (va-2-115.ptr.blmpb.com [209.127.231.115])
	by imf10.hostedemail.com (Postfix) with ESMTP id 10CE8C0017
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:02:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=jUJz+CnS;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790776973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WaE+XWWIAh7wnvjsJHyHq9GcUuzsegZPrdGo3qEDS8I=;
	b=7g13KK6U3YUVIyCePXEJOmbd6wjwLtNp5alLcmP797lBV3x1fsezJ7VNFksMmxLJMEWDah
	ML9+NRWXMhlWKG7U6Atg3J2KCfA4DnuROLgcZZTr6mst/Bz30wgjCjoflkARKAtgW39t/F
	3i+4s9vumMC7t5Mho/BkwSjiXQzwACI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790776973;
	b=Aim22+2/jsYuhoB37rOv9dbSTmEPwqf2960WodHmtNavStqAEyUgiJYlnKAYMeY825hoBH
	CyCvZB1jCozZndAB3Ak15lgFWw/wrD3xKbSe3/1xCPJMFIAyYrMTztletsw+GJC3Eh1kZi
	82/VPda2B+UVxl5B1u9sFkfNBur9XkI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=jUJz+CnS;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1790776964; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=WaE+XWWIAh7wnvjsJHyHq9GcUuzsegZPrdGo3qEDS8I=;
 b=jUJz+CnSOqgqoBn9Hc/HYuORMShKcjbAaBXhBH6tBK4ZTVT20sLZU13QAGOquh440muTy+
 LfyXsFrvNZXXBslpnhQB7TxZhuC9N2GWVbXTTuq+tNGHPpQvHO/a30NGeV1vBIUHgE4SNZ
 /0NHnlLPqSou8wkk4UPhBUNbPAUBKrma8E8gm8KRbNsVEFnF8hmJHRwES6ECPLqgTp2Dl2
 zquanW77auaekDGa0lTL6MY2mZE5rhIeVaFbd9etUwnkz6/PEI+npxhE+6sVTDEJK5uWHU
 Py4llw4JunqLEd7JxG9uCDOJsXxMSP2r+4deauH6DpofbRj+3YbQX6VY0guiUw==
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	<akpm@linux-foundation.org>, <ljs@kernel.org>, <liam@infradead.org>, 
	<rppt@kernel.org>, <mhocko@suse.com>, <corbet@lwn.net>, 
	<skhan@linuxfoundation.org>, <ziy@nvidia.com>, <gourry@gourry.net>, 
	<ying.huang@linux.alibaba.com>, <apopple@nvidia.com>, 
	<linux-mm@kvack.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference with MPOL_WEIGHTED_INTERLEAVE policy
User-Agent: Mozilla Thunderbird
References: <20260930121154.687586-1-joshua.hahnjy@gmail.com>
Date: Wed, 30 Sep 2026 22:02:23 +0800
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26abd1683+d9b0a1+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: quoted-printable
To: "Joshua Hahn" <joshua.hahnjy@gmail.com>
Message-Id: <2e3f12b7-0dac-428c-b70b-07e1f63de028@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <20260930121154.687586-1-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Stat-Signature: fw88x8aohcawat5wtw4ewozxjoco659t
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 10CE8C0017
X-HE-Tag: 1790776972-348461
X-HE-Meta: U2FsdGVkX19V8esr7U0lkLYY3XhmWkccxEYXnWgRSGOoXK4lxkeCiqymnbkgY9Hp7Y2xH1PwFos5FJ8wcIjTJT5O2bIibAmKlrR49ePSmGtEUnHAdSbzNIv5zc90p2pvADrrOqzdUj2MnqEDGBjSwunkEZOLGsTsGIXpl+NAauU0MCmqrQTpRXaiAQfdXsbLMw7h8Fjm8dyrXfPX1H9zR7TlpHCWeDGNOcaqA5fndtMTvXHH7uMtWpBui82dIE7xBSk4oxsjmt8i/dNTTubbcYQHPX/EPSTpHd8mEMpqxPfcIZYTvyGOk/gcP0MOhGxsz1+pIZLiycromd1zhrv0FvZcdemYVOLDtcEUA1G6UPN3Hq2CKx4SPGHVzxSjsKzpp22ukS3aYNcsKEty+JlJIA+31BA9v9U1jVEykqJDnBnGI3EMOp8kQ7NxVNDnQ55AEuCz1lhGJpC4tlXlcDcA0EpPCKxt2Aa6buVKJ3T1grzTzEdy7hVYqX5wg4Ru2B6m+xzf58VUBZ07kPyEzx7+XVZgpkiX8IVj9NzlNGmQIfSUiT3RtnHgeuPpuiN2y2Lejf7zvnT3D41T96DBYqVhofO3bropz/NV9EO6DkkHXAeo3GfdlOm8WgUSe5y7VWMKOSHhs/08cVWjfc2US3pTSL1tmpl9eTjbqm6g5Y/nXpcj+0qxqwCEf4xa2qVJIpzy/BZH4RLtw5SnFBDLOJGiUoJ3HNrOWI7VhtbQSdQ7YJRMSunPDrkjTnV7lAn6KNZtJlZytr6BTWkj0iT/7UIfvX2F+Pt0gK7+HC3kEiUxE30mnf5+JT0TgvtzAN92NfeqvEb06je3+u8Hu113vx2u6Liez7zhS9PBfDD1TgOJRjYa/0PR1FASpjyyGSuNLzrk6ATS57mFBSp429adl/RB/PO9JdTa/7t303HFv/sGYNaWdPwGOnjplQ9sIJE9A8gWva13V9REUWMIKhXlTSy
 5G08Dw13
 PDAFELgba+E+JNUlTcRia3KKI3CPdbzFXaY6WbxZBKFzk2+j8Ep9a7o7B91V56k0fgCmOpEnRqYqhI4TG167USrc1JvMs+itEBjd4hr7CHPuJfZgaAXAWwV7PxGReoroaYx8GC90S+1UiQ87G0BGyKHjI8w1XB7ses8Dk4JF67P+jEBXw1NlakTs5PBy1pCs9unPp6jPbkfRigwxIS/uHVgrlVjO6XRuyGbPQdpWLcsS0tFrP46twicDC+qrciBd0P4MGEu14zBh2IEer0DYt+63iG9PNGpgz8+lDMqn4R+J7IrgaUSbO+qiNxMPJ5fIxfZrqi8WAyyCqMuODbrYkLMvG+hG7OmmOo7RZcsbBPPPabhoHYV/865Yg/YVC3h2Ih1Cb4ld9JZ4FSW9gwrQPMeu2ewBeruVMhgCUKAKiMrjtojk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/26 8:11 PM, Joshua Hahn wrote:
> On Wed, 30 Sep 2026 19:52:05 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrot=
e:
>
>> On 9/30/26 7:26 PM, David Hildenbrand (Arm) wrote:
>>> On 9/30/26 09:26, Li Zhe wrote:
>>>> MPOL_WEIGHTED_INTERLEAVE is useful on tiered-memory systems because it
>>>> can seed a workload's new allocations across fast memory and slower
>>>> capacity memory according to a configured ratio.
>>>>
>>>> That initial placement is useful for workload managers and orchestrati=
on
>>>> systems.  They can take the amount of fast memory and slower capacity
>>>> memory on a machine into account before starting a workload, and choos=
e a
>>>> weighted policy that seeds the workload across the tiers at allocation
>>>> time.  This avoids starting from an all-fast or all-slow placement and
>>>> then relying on promotion or demotion to reshape a large working set.
>>>>
>>>> After those pages have been placed, however, the policy cannot current=
ly
>>>> opt in to migrate-on-fault placement.  set_mempolicy() and mbind()
>>>> reject MPOL_WEIGHTED_INTERLEAVE when MPOL_F_NUMA_BALANCING is specifie=
d,
>>>> so memory tiering cannot promote hot pages that were initially placed =
on
>>>> the slower nodes by the weighted policy.
>>>>
>>>> Initial placement is only a starting point.  Pages initially allocated=
 on
>>>> fast memory are not necessarily the long-term hot pages, and pages
>>>> initially allocated on slower memory may become hot as the workload's =
hot
>>>> set changes.  The policy therefore needs to be able to combine weighte=
d
>>>> initial placement with memory tiering's NUMA fault based hot-page
>>>> promotion.
>>> Ok, so memory allocation will respect the weights but balancing will ig=
nore
>>> them? That really sounds rather odd to me.
>>>
>>> And I assume that was the reason why we might have disallowed the combi=
nation:
>>> it turns a weighted mechanism into an unweighted mechanism.
>>>
>>> So are we really sure these semantics that you would essentially set in=
 stone
>>> here are the semantics we want? (ignoring weights)
>> Yes, that is a fair concern. It does look odd if the weights are
>> interpreted as a hard resident placement ratio.
>>
>> My understanding of the existing MPOL_WEIGHTED_INTERLEAVE ABI is that
>> the weights are allocation weights, not a long-term resident ratio. The
>> sysfs ABI documentation says that these weights only affect new
>> allocations, and that changing them at runtime will not migrate already
>> allocated pages.=C2=A0 The implementation also has normal allocation fal=
lback
>> if the selected weighted target cannot satisfy the allocation.
>>
>> The use case here follows that interpretation.=C2=A0 The weights are use=
d to
>> seed the initial placement across memory tiers.=C2=A0 After that, with a=
n
>> explicit MPOL_F_NUMA_BALANCING opt-in, memory tiering would promote hot
>> pages based on access patterns, not based on the original allocation
>> ratio.=C2=A0 Users that want weighted allocation without that behavior w=
ould
>> keep using MPOL_WEIGHTED_INTERLEAVE without MPOL_F_NUMA_BALANCING.
>>
>> That said, I agree that allowing this flag combination would set the
>> semantics for it.=C2=A0 If reusing MPOL_F_NUMA_BALANCING for this is too
>> ambiguous, do you think we should model this as a separate opt-in ABI
>> for "weighted initial placement plus access-based balancing" instead?
>> For example, a separate flag or policy mode would make it clearer that
>> the weights are not intended to constrain migrate-on-fault placement.
>>
>> If the allocation-only interpretation of the weights is acceptable, I
>> can make it explicit in the commit message and documentation in v2.
>> Otherwise I would appreciate your suggestion on the preferred interface.
> I see two usecases for weighted interleave. Let's say you first allocate
> all the cold memory, and then all the hot memory using an interleave
> policy. This leaves the same hotness in both tiers since they are
> interleaved:
>
> In one scenario you might genuinely want to keep some hot memory in
> both tiers to maximize bandwidth utilization.
>
> But in the other case when you are not limited by bandwidth, you might
> indeed want to start out with a weighted interleave allocation to
> reduce variance on where hot memory lands, and then make promotion /
> demotion decisions based on access.
>
> Zhe, do you have a specific use-case in mind? For the second use
> case I would be curious to see if you see any meaningful performance
> differences in startup time when comapring a workload using other
> mempolicies for the allocation and then tiering vs. using weighted
> interleave and then tiering.
>
> But yeah, I think David is right that we should go over the semantics
> and really make sure this is what we want to commit to.
>
> Thanks again Zhe! Have a great day,
> Joshua

The use case is closer to the second one, but the main motivation is not
only startup-time performance.=C2=A0 The more important point is that each
workload has its own DDR/CXL budget assigned by the workload manager.

MPOL_WEIGHTED_INTERLEAVE is useful because it lets new allocations
follow that per-workload budget from the beginning, instead of placing
everything on one tier first and correcting the placement later. This is
important for workload orchestration because the workload starts from a
placement close to its assigned DDR/CXL ratio.

After that, we still need memory tiering because the initial weighted
placement does not know which pages will be hot. Some pages initially
placed on CXL may become hot, and some pages initially placed on DDR may
be cold. The intended model is therefore: weighted interleave provides
the per-workload allocation ratio, while promotion/demotion and reclaim
exchange hot and cold pages and try to keep the workload within its
assigned tier budget.

So I do not expect MPOL_WEIGHTED_INTERLEAVE alone to be a hard resident
ratio after migrations. The ratio is part of the workload placement
policy managed by the control plane. The kernel side still needs to let
hot pages from the slower tier be promoted when the workload explicitly
opts in to NUMA balancing.

Thanks a lot for taking a look at this.

Thanks,
Zhe

>
>> Thanks,
>> Zhe

