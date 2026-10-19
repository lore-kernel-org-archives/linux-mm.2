Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0F7ECCF2D3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 07:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B27096B016B; Mon, 19 Oct 2026 03:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7876B016C; Mon, 19 Oct 2026 03:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EDF96B016D; Mon, 19 Oct 2026 03:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D89A6B016B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 03:51:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00EC6A0680
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:51:06 +0000 (UTC)
X-FDA: 85338604974.18.F86DD24
Received: from mta1.migadu.com (out-50.mta1.migadu.com [95.215.58.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id BEE888000A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:51:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lIGxj7Mi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.50 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792396265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7qZaDy+NlMF6Jfo93oKKnh49XozYmZutq3k/aN20Vf0=;
	b=a0yTjZrhHi6eD1Ri05AFKGz18i66wTAkaWWBjX/+eVdISD+6rGXskHTLOhZTsVoqxeJGJI
	EEvX2vwtYI6h/YKXdhfIgwXUBtqJuBwCUCFnEKtAR9wUt/d6w6X37y5l+ea3Jl9TVSex0K
	9JeuE+JgFqvApLZIGjnDjXinlZmOBro=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792396265;
	b=S6RNUZDWVfZX/Kb3gqGZNF/AhSNYxe12fMYNwlX61QU9CghyxLZwUZ0/soXpDuculhrz3E
	nbfj5JpXIKisOOnUdAXfrn6Z1SC8bJQ8Qb5b6IzP4VWNnaUsgUvUHuc87REyfPuEDasOsa
	kHDZ94jw8infsVTmQs/BhKpZjnidc9E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lIGxj7Mi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.50 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=hjF8tZ7rA6iLI0wdX17D/6yLew+0TeKbdr1X0twuh94=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792396263; v=1; x=1793001063;
 b=lIGxj7Mij5RFMLv6ysso3EZicJKMD0fiibM4JQVtcJXN3SXgCzkD1zzdKQr57NrBMRRT0ftQ
 HQqeCrKzBgMZPyVPMc3fTj7rjlHV6n7ty8DSrT5QCdl5Lv7iCRdIhIOqMGMEASSlF6XVH3vI5As
 2qwqiQi8GAECFL1Sx2zl0MJE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id e63287af24581460;
	Mon, 19 Oct 2026 07:51:02 +0000
X-Mizu-Trace-ID: e63287af24581460
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 0/5] mm: hugetlb: add CMA support for PMD-sized page
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <4a7ad39d-fee6-4390-beff-d40ecf49cbdc@bytedance.com>
Date: Mon, 19 Oct 2026 15:50:48 +0800
Cc: Qi Zheng <qi.zheng@linux.dev>,
 osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BEADD50D-94AA-4B05-B9AD-136E37247FDD@linux.dev>
References: <cover.1792136742.git.zhengqi.arch@bytedance.com>
 <FA455F0C-0A46-4B5B-AB50-E9968001D2C9@linux.dev>
 <4a7ad39d-fee6-4390-beff-d40ecf49cbdc@bytedance.com>
To: Qi Zheng <zhengqi.arch@bytedance.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BEE888000A
X-Stat-Signature: ppyqy1ip3y6u9o83gbxrwsgxf7c9xwmg
X-Rspam-User: 
X-HE-Tag: 1792396264-533229
X-HE-Meta: U2FsdGVkX19glhu/uXzrN0uOiuze0oIRijMSq8ZLxaD36FQKvOjn6/BnvRW7G9wbfK6tuUp6BmNMhSC+zIQwA0R1hXbKcNJsOMcE0+eTMKtdO0XWLgeSNsTpJHVPd/l/i9o5yEuRLsPizQPWikSzk7FqvEKGefqex2snKu+dnhKFAzro1fcrOZFxmhIkduMBYHUVirhvCuDBJUP6cDNSlSu4PE8E362LjenDWz0DKTsnqXYlyIswA1WuRLKwZtI9F9SuTb49kRiHRIUOnWd3iew8lZpKffUx/mKNCbKt35Y9YeTc/bbTFW7qwRlhMeBEJXRaJC0dd4ENi9Z1xkQwmy8KiCFMH18sIEnq7MGwr9wOFAj64AocVFxFWtxcHmHrV+uEYmKlKprnMQlaHFEGTE7WXWvSykJer/lhYg4FE1V0FzpsvvdoLABQYfh1gRxL/HF7zmDXYcG+xlKoByXKvF3nz1qgHous2V2UwWqDHhLCey4JrpnptgT6DalDMbF3ORFROwPO/UyTC6o4kOmzFhgZ/6z614XThA2A91m4fA2GpMcVlzfNZyrlw0leGixJhFZQcH7XanTnMDYVOJgJo8pkqkQqpIM/cN45SWMKPkJYODaqsTiHdEhnXnHyL8a0Mr0gDnSiNQtoTzgliKpVzl59m/VC6N9wKtQ1GSyDwchjS8JZiTax3Vz6bqLv3+5wmOjNI0D1+sOxBkOgM5WrmElVyRZgTJERwlAmNeQyTo9PsnJkssgN57iD5GNfUEGGqSSZy79CmSYTpPnNu+dX5/WQeboM2V8dFwj6+GJo3wcfSIcVBvIINP1B4Yr0/7NZtvF6rWSjlYvPov4INMPZy1ZG3+RBWats9Niowcq87m+De6UaW3nMjpqjE8NPp9S6jku63wR7/DLfooA2us1SZnYUz7574uT6Vd4t1PwxcYAiVDSyJ419twX+OgPGN0whcDuxFmlUizbOa8zB5qt
 N+3ZaTgt
 wo5OIbHNZitCOrFjR5wHiNpfHW11nafrHAeFLMO52wQMcGH/Bo4XlkZl9enU7nxOWYjX+8yky92NaSyHItNie16fou3MOHaFiLMN86vAHnwDFOD1fYYNLXkceB/7Kppgh09qQE8H47MwhqXCD+T+cRTM6F6hh0Fr/+0BZ5EOdC/5gSWmt3XGf2OwPJRRdLAy770mkllr1QX4rkiaOFyYAT99JU2MA7fhl6u/cPzuzA7Xwi1xuk9HiICwGw9McqgjE7Bw4PasXyrzn0oAVLmEjuJs/8BT7Tgs+adpZNV5Yq24QosfmBeplwDJXeuAYGw6oCisJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 19, 2026, at 15:37, Qi Zheng <zhengqi.arch@bytedance.com> =
wrote:
>=20
> Hi Muchun,
>=20
> On 10/19/26 2:50 PM, Muchun Song wrote:
>>=20
>>=20
>>> On Oct 16, 2026, at 18:07, Qi Zheng <qi.zheng@linux.dev> wrote:
>>>=20
>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>=20
>>> Hi all,
>>>=20
>>> Allocating PMD-sized HugeTLB pages at runtime can become slow or =
fail
>>> as physical memory becomes fragmented. Reserving HugeTLB pages at =
boot
>>> avoids this problem, but keeps unused pages unavailable to ordinary
>>> allocations.
>>>=20
>>> Live upgrades are one example: they need additional HugeTLB pages =
only
>>> during the upgrade. HugeTLB already supports CMA for gigantic pages,
>>> but reserving a CMA pool for 1 GiB pages can fail when physical =
KASLR
>>> and other early reservations leave too few suitable 1 GiB-aligned
>>> ranges. At runtime, 1 GiB allocations can also fail when pages =
cannot
>>> be migrated out of a suitable contiguous range.
>>=20
>> Yes, that's our use case at ByteDance. Allocating a 1GB HugeTLB page =
from
>> the CMA pool is more prone to failure than allocating a 2MB one. To =
improve
>> the probability of successful allocation, we typically configure the =
CMA
>> size to be larger than our actual requirement, keeping a certain =
margin to
>> handle cases where temporary kernel operations (such as DMA) prevent =
successful
>> migration. For 1G HugeTLB pages, since the margin must be an integer =
multiple
>> of 1G, the extra memory configured as headroom is also relatively =
large,
>> making it less flexible than 2M pages.
>>=20
>>>=20
>>> Extend CMA support to PMD-sized pages so their backing memory can be
>>> reserved at boot while remaining usable for movable allocations =
until
>>> needed. This relaxes the reservation alignment requirement and =
reduces
>>> the contiguous range required per allocation.
>>>=20
>>> The series adds an optional @<page-size> suffix to hugetlb_cma and a
>>> separate PMD-sized pool. For example, on x86-64:
>>>=20
>>> hugetlb_cma=3D4G hugetlb_cma=3D1G@2M
>>=20
>> Different sizes of gigantic pages already share a single HugeTLB CMA =
pool.
>> Given that, why not let 2M pages also reuse this same pool? Would =
that make
>> the overall code implementation simpler? And if it does make things =
simpler,
>> should we go ahead and do it first?
>=20
> Sharing the pool would simplify the implementation. My concern is that
> small PMD allocations could fragment the default pool and prevent =
later
> gigantic allocations.

Yes. However, the premise is that there has to be a mixed-use scenario.
I'm not sure if this kind of mixed usage is a common scenario.

Of course, we don't have much experience to draw on, because on most
architectures there is generally only one kind of gigantic page, and
prior to this, mixed-use scenarios could not arise.

Therefore, I think that before the need arises, a simpler design is
easier to maintain.

Thanks,
Muchun

>=20
> 32M allocations can already cause this, but 2M allocations can block
> the same number of 1G-aligned ranges with much less allocated memory.
>=20
> Thanks,
> Qi
>=20
>>=20
>> Thanks,
>> Muchun
>>=20
>>>=20
>>> This reserves 4G for the existing gigantic-page pool and 1G for the
>>> PMD-sized pool. Existing unsuffixed parameters and gigantic-page =
pool
>>> sharing are preserved. The new size follows the architecture's PMD
>>> size rather than being fixed at 2M.
>>>=20
>>> The preparatory patches introduce per-pool state and prevent =
recursive
>>> CMA allocation during migration before enabling PMD-sized =
allocation.
>>>=20
>>> Thanks,
>>> Qi
>>>=20
>>> Qi Zheng (5):
>>>  mm: hugetlb: add explicit page size to hugetlb_cma
>>>  mm: hugetlb: group CMA pool and reservation state
>>>  mm: hugetlb: track CMA reservations by page order
>>>  mm: hugetlb: avoid recursive CMA allocation during migration
>>>  mm: hugetlb: enable CMA allocation for PMD-sized pages
>>>=20
>>> .../admin-guide/kernel-parameters.txt         |  39 ++-
>>> include/linux/hugetlb.h                       |   4 +-
>>> mm/hugetlb.c                                  |  80 +++--
>>> mm/hugetlb_cma.c                              | 328 =
++++++++++++------
>>> mm/hugetlb_cma.h                              |  11 +-
>>> mm/mempolicy.c                                |   2 +-
>>> mm/migrate.c                                  |   3 +-
>>> 7 files changed, 306 insertions(+), 161 deletions(-)
>>>=20
>>>=20
>>> base-commit: b810335a0699d1810683796b0e3ffe8827ddfe6c
>>> --=20
>>> 2.54.0



