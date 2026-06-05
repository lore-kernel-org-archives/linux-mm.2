Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AA67CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BDD76B009F; Fri,  5 Jun 2026 11:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 095906B00A1; Fri,  5 Jun 2026 11:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEDC66B00A2; Fri,  5 Jun 2026 11:18:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DE7EA6B009F
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:18:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 83713A01B3
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:18:17 +0000 (UTC)
X-FDA: 84846215034.06.9B69929
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id AF1D22000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:18:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GSPu40WW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780672695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bpBz50L7GInctas+/Il3i3Hx7c4Pv4RIfM6k49q0DxM=;
	b=p2q+Lf6VIKwgjplr5xx0vN5zLcYATdEE/JJ7DUTZlNhvZ6wgc2P9yIBJDIMVZpFuEQJxqE
	O0LGypEkBi7OmLb5KWSkENmFQMhxMFENPqd5lEOBR5Vlskw8EWXpVvlaC8NuGcENLJOUFJ
	Gf3HAZ7+9wHRWP3WRkNepYy0+O0hg5E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GSPu40WW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780672695;
	b=buI3wDBvUUXenPMzxnspAm4rugJ0uIg4DZwJfkp+Nd049nTHI7Pzatxm2vaaYhX44gerqb
	eeGsWWxeJasCMrVhqVcElcGYIsXCsxM0i13+OVvmzhtRK0Tj9L4WYM+diqrNGObsKOwZRI
	Utb0AaSeeBCpiEFP2diNt5f+Hm3QKyA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E38F843278;
	Fri,  5 Jun 2026 15:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696671F00893;
	Fri,  5 Jun 2026 15:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780672694;
	bh=bpBz50L7GInctas+/Il3i3Hx7c4Pv4RIfM6k49q0DxM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GSPu40WWv9onXNY6VO0dlcw7gsX0kg6588NMgROX+7us5AEUFjsK+9/iM1JALiQve
	 s9FIHVxGScwUx0snSzqh7890Rvu3diNQ15ki1tIq4j85wka8H7p6WucwIqbQyOM2I2
	 hBnkXoJI7ZJAVkpkIbJHfqCEh/o6znOhql5PeV2JEp1IfSIOLjl5P7nQ3iis3Uzq+P
	 9u60D0CPpvy8fLYJp7JncpQfH9t2EKVDtKWBGdJkd2OBdXVDzj6rGRatKgUGb8/23Z
	 3WlhRQF0kKRXyR0Kptz8QJfDNfZ3JHMDu8VjLy2Y3RB4RxB6Mo2Y/6NFLb9Ra1VK57
	 7YcT54/CLRijQ==
Message-ID: <25c4bc47-b65d-4c04-8a8f-18eef2b5566a@kernel.org>
Date: Fri, 5 Jun 2026 17:18:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: don't allow empty relative nodemask in
 mpol_relative_nodemask()
To: Farhad Alemi <farhad.alemi@berkeley.edu>,
 Gregory Price <gourry@gourry.net>
Cc: falemi@asu.edu, Yury Norov <ynorov@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Waiman Long <longman@redhat.com>, Rasmus Villemoes
 <linux@rasmusvillemoes.dk>, cgroups@vger.kernel.org
References: <20260528124133.c88c27b11a8ea0ef05e494f7@linux-foundation.org>
 <20260529152616.2308736-1-joshua.hahnjy@gmail.com> <ahnRIDBk4bQ3xX2q@yury>
 <fe33c767-ea11-43e2-8732-f752c9c1205c@kernel.org>
 <ah6X-RtVX75YP7VX@gourry-fedora-PF4VCD3F>
 <c98eb14d-b878-4eeb-91f0-d2b1d4407e1e@kernel.org>
 <ah6oS7wiGB4u4-eR@gourry-fedora-PF4VCD3F>
 <CA+0ovCiEz6SP_sn3kN4Tb+_oC=eHMXy_Ffj=usV3wREdQrUtww@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CA+0ovCiEz6SP_sn3kN4Tb+_oC=eHMXy_Ffj=usV3wREdQrUtww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AF1D22000A
X-Rspam-User: 
X-Stat-Signature: puhhqip33uhjyw1kqyg95py178hxabom
X-Rspamd-Server: rspam09
X-HE-Tag: 1780672695-46502
X-HE-Meta: U2FsdGVkX19PiQ/hMPA6HGhr8JD/cnNBZYqd6VNM8Zxy/sqqhrZn8RS2Y13o5i1pyDImuWCcgJevGo4vfS+EHLld9Yxm7ldDgGhJTy+aUv0xfsDUram6TqMMLcuJUGDEPSpjyq5Kh2sLzuKjEig0YMX8H39H8dosWzkE08X4qJ430dKFdCI3eG6LA/6dNbTxVnLy2THhPa9dSCWhy4DYlGpso4u6mcAWAa/AySdDnv/+tI2t0u5p4IKBppkNM9mX60PKm8aEjAsST3lCM93IodQoiWakRvPlC2Y/+ce55pfcGH4RfU8RnJ3kBsFS8MflbxgoDbVjoAoL9MsP69q4aGN1r51T9KwBp5N/P+7ICdTdblyMuNS2aFKNs04ctKKMS7cXo4Uw+AzAUMILXXc/gIVD3dVvoO29XVpl4nFyeIwhgw/jrKwIdDaUnGXosiKH4NDCrja9nRKAwBq8kBXzif8GzLSac+EUFSwCIM/N36dl8YLgMK2UhNI61RNauzOYWCcwPoYeZKuzkBhPr6zpdBLeh3J24whl09OBt4UstIyyHL5HegiLpHWSdyuPPz9wvPr8otEuzdvuvbGqkLgIFk5TBPt9SgygjqHkcvNW8fiTf6VJJftAwr4Z5+0MuTJu9wLLO79POyI7dnIDGXCrGeq0ELtzSdXAtvealSxUoe/vNzLz3pe9KCdRoDuaq+J30n/Th14KHjY7C286H1o2tlVoFrbCitn3vs+xuBiqFj7VvombsoZkK4rlrGX5MYHCbql82OozL+qsMTeuusJ+uZQkjZLqcFZ9SdnS/MW5Lrlmt3J9/AVksbSa29fKG6eIbcF6QZWoz6R/l6t1RT0EXAhW8lVa+OmWBqA7gpat8q7veuz1aGnfvnKKCAZQA9KKKD4qs52UwhRk0b0Jk9WkOS+gsNytd9Vs//4BfqMhJ8CO6JPn8BuFmTz1LIS49NKjnYT6JqcFPmpoLwf+bBi
 X87I84tF
 tOgunuadhzzdnx/9IauM4yMyFJo9ywYFdNVQ4oQYt7202v1BhUfsMeAddP8tdkCd4zN+Wx9QqiW5hUkgTL7M12PJJ3VKQ8FWYAhiyVopND3oDpvl6o2UX00rrNjgb8UD9rt/f1ed86hnlALyakLfWPFq/iuPkA0hCU40e4JEWTWO7DLuMMAHb8PzwSJ5lRneElV8COVlAd/6T9EI7Lrjfn5PmYHxMox7p0xNh65V7pfCqrQDbawrdnNyj/yJRpkbpjg7zwQQCtpYlfctXjSQ/Fhw0qlrgvh+zmYuL5/GtHvDSy2auB14a8ugzqAk9itDp/IKB0QsGATFxvXcTVHZdk/FBKY7MnHqCV5NeP2ul2saQ8Mtb3loX9nMNMnhq4pUdCqXc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 17:01, Farhad Alemi wrote:
> Confirmed, with a standalone reproducer (attached); it panics linus/master
> at e8c2f9fdadee. cs->mems_allowed can legitimately be empty
> on v2 -- a freshly created cpuset child that never had cpuset.mems
> written keeps mems_allowed empty (never initialized) while effective_mems
> is inherited non-empty in cpuset_css_online(), and v2 allows attaching
> tasks to it (the empty-mems guard in cpuset_can_attach_check() is gated
> on !is_in_v2_mode()). So the non-empty guarantee holds for effective_mems,
> not for the configured cs->mems_allowed; forbidding empty cpuset.mems
> would break v2's inherit-from-parent semantics.
> 
> The reproducer enables +cpuset, mkdirs a child without writing
> cpuset.mems, moves a task in, mbind()s a VMA with
> MPOL_BIND | MPOL_F_RELATIVE_NODES, and offlines a CPU; the hotplug walk
> then calls mpol_rebind_mm(mm, &cs->mems_allowed) with the empty mask and
> folds modulo nodes_weight(*rel) == 0 (console logs attached).
> 
> The newmems instinct looks right: it's the effective, online mask the
> task is actually allowed to use, guarantee_online_mems() keeps it
> non-empty, and it matches cpuset_attach(), which already rebinds against
> cs->effective_mems. The fix this implies:
> 
>   - mpol_rebind_mm(mm, &cs->mems_allowed);
>   + mpol_rebind_mm(mm, &newmems);
> 
> I built the current base (e8c2f9fdadee) with and without this one-liner:
> the unpatched kernel panics on the first cpu1 offline, while the patched
> kernel runs the reproducer's 8 offline/online cycles cleanly, with no
> divide error.
> 
> This regressed in ae1c802382f7 ("cpuset: apply cs->effective_{cpus,mems}",
> v3.17), which moved cpuset_attach() to the effective mask but left this
> rebind on cs->mems_allowed.
> 
> Happy to send this as a proper patch (Fixes: ae1c802382f7, Cc: stable,
> reproducer) if you agree the cpuset side is right, or to test a
> mempolicy-side fix if not.

Yes, please send a patch, including a high-level explanation of what you
analyzed above!

-- 
Cheers,

David

