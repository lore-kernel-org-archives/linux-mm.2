Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACA45CCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 08:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858E06B0176; Mon, 19 Oct 2026 04:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2CB6B0178; Mon, 19 Oct 2026 04:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A9746B0179; Mon, 19 Oct 2026 04:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 413676B0176
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:44:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F9A6A82A2
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:44:25 +0000 (UTC)
X-FDA: 85338739290.20.5EF1BBF
Received: from mta1.migadu.com (out-73.mta1.migadu.com [95.215.58.73])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4966B4000A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:44:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wQRzvpe9;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.73 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792399463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VuUI5I5Plith8bOrcJuwZxksr2hAMP7W06KU56M8g1s=;
	b=t6QiK1pDxBhaSgU3L7V57AG6R3/oXByduDOdaKT62J2Ez3CgQn0t1B4ptI0GvDqAbmhg7z
	LsExa4tnmJMXI1VSXFDJuybjPRA/MVP8Nmy2CtoJnyQ/DioblBUBgnlAIzHFa7Q4pnqM6H
	rgBathZmW2Le9wvQGw6C0/xRGrr+djg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792399463;
	b=QHRUFT8aubw50ScWq6z0BGmqydbhPlz3+YDTnF4ZArLcHympbbWd6xgeUe0cC62GT3zTcM
	foFChP85hCr4IcMxFTjEaVASNOEuUZIBx0ul2jKIGCUVO23ZoRs4V88LmLWCV3nCWgSpGQ
	FNhEVhfzZrx+babvE0MSNgHNb2pHPrk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wQRzvpe9;
	spf=pass (imf01.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.73 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VuUI5I5Plith8bOrcJuwZxksr2hAMP7W06KU56M8g1s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792399457; v=1; x=1793004257;
 b=wQRzvpe9wUABp18JXIWXaXVbvfvnUOfTdmsOuSBjpYKXd5wlhb9iT4fwgO9lpA7M5zDgX5Bl
 M0U4ex92ZDSWd/8tP/RCIsUsO1JkZ7GvlJqddUi9SwvMNNEDr81IgP3W8CIT1hcMj/41GN1CPr7
 PP+I4loiiH1IegBshHkYaSzE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id ef060ed4dbf3e91d;
	Mon, 19 Oct 2026 08:44:17 +0000
X-Mizu-Trace-ID: ef060ed4dbf3e91d
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 0/5] mm: hugetlb: add CMA support for PMD-sized page
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <988249c7-abf0-4f4f-9386-27e835a4d2de@gmail.com>
Date: Mon, 19 Oct 2026 16:43:58 +0800
Cc: Qi Zheng <zhengqi.arch@bytedance.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EE02C2AF-E4BD-4854-B235-928842456253@linux.dev>
References: <cover.1792136742.git.zhengqi.arch@bytedance.com>
 <FA455F0C-0A46-4B5B-AB50-E9968001D2C9@linux.dev>
 <4a7ad39d-fee6-4390-beff-d40ecf49cbdc@bytedance.com>
 <BEADD50D-94AA-4B05-B9AD-136E37247FDD@linux.dev>
 <988249c7-abf0-4f4f-9386-27e835a4d2de@gmail.com>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Rspamd-Queue-Id: 4966B4000A
X-Rspamd-Server: rspam08
X-Stat-Signature: fijhmyoup9ecbudwn5nx6wtqpx4kskuk
X-HE-Tag: 1792399462-24973
X-HE-Meta: U2FsdGVkX1/Fi7ljZ/bCLr0Y+JRdVtFWnjJxaE85Nd5GLM4AArgfVvmyHIvS6aRasyNiSuSunx/Z6sjVq6im3XxRzZMeesIxHaMV/MBUKDQ7kRjfJnfhuGAKQHuOfxrZnr7hrRsVMZdGrhg4gPIUC6na8RzOJxQvcEJpsmkOal6ZDN+c/EsplYxc+dhjMXMz7C7zNHCuGrGwugeqO2fQehkS63OTd/gfsW2fK3WAQETs8tu6bVFRTXZ+1qCXU+GYooJzPQ8nSB7DEfo40Fo+kqvJESwYtANTs0vkX9SjI2/DzXZiW/QwnXjhmP/2//eo0YTfFNraf6XoASsl/ALV1N86U9QwFPpbZsn0Zn7icNWVdPWvEg8Qg0MdLfYlDEig1Mu2O8vvzo8Rk/to/habfRwinBBLssunI9hXJpzswaTTRfhrw9uoMDpDLIV33HC3iJGYbrs6r3fzjZuI5qVo/9ABXgIKgX9g4Vc0zn1ooQNIIxrHHV+7obrhXTDrO5SEnn/lqHiArIXNckTwZs7vLfT9edCL5x90nSqGh+104Ugc0y9+Dzy1BeYfER/rBeJZU1lLioxHrPCF/MDF1t1F+AVZ3Ah+9dfMy3czkBIVbVen7P+BwtKqHsDL++lza6mzq4eB6jHFBi/J7u8Zbt6/y42hUT55d1s6zI1Q9b/seQtm/xr9hdyS5XJKW59Vaa3cDW7wSr9QKq0PzuBIllsCW6EYhVWAW7dxW3ujYwU1DZAbHGxERHi3WDEW3c1/EwAdd1JJKJekGOBS88rEni50jdcBiZcY+zJJyVEgHgWv2taXJUV0kRlHNbtbnXEwtJYJsCn2zbORtT8JySgn8cj7CRdBWtQjdfnBmL2I6/deWZZvd1/ycTtaWFHn0X0LqfvXbO3hO6vI8XZx2YXP1pzjOZOJG9rCH1YANeOuhRsGB+YneWaYUvJCM3oUXYy0ME+kxc4c/0kWkP7H2Ruphwk
 qiAPQK1d
 jkOtC0euTqqO2GCFEFgFAkMHgevSfK3HEaQY7r+eCMmetLb0Mmzm6v8YHFs1hnjoxkn1Qtw5cyUK++HRSJSDg6d4A+5E4JFgoMD0ze8xPPCV9VnvfPv103cYooJDeaJ9D1ztiPxZMVAxYNdBHtUgHOoUsvsgqxck6+akySJFANFKbKIMK+0ASXLY+84XBrmLckU5aUtLnhSkHneRmeSFJmHOTosU/9fUITq/HIYCoELLcj6/iIutfwIe7FKmic7880Zeyx/cll5KtTHpLmva2zf+sHnPx7QdHZjSvFJg+02zHp/34tE3cvtLCoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 19, 2026, at 16:20, Jose A. Perez de Azpillaga =
<azpijr@gmail.com> wrote:
>=20
> On 10/19/26 9:50 AM, Muchun Song wrote:
>>=20
>>=20
>>> On Oct 19, 2026, at 15:37, Qi Zheng <zhengqi.arch@bytedance.com> =
wrote:
>>>=20
>>> Hi Muchun,
>>>=20
>>> On 10/19/26 2:50 PM, Muchun Song wrote:
>>>>=20
>>>>=20
>>>>> On Oct 16, 2026, at 18:07, Qi Zheng <qi.zheng@linux.dev> wrote:
>>>>>=20
>>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>>=20
>>>>> Hi all,
>>>>>=20
>>>>> Allocating PMD-sized HugeTLB pages at runtime can become slow or =
fail
>>>>> as physical memory becomes fragmented. Reserving HugeTLB pages at =
boot
>>>>> avoids this problem, but keeps unused pages unavailable to =
ordinary
>>>>> allocations.
>>>>>=20
>>>>> Live upgrades are one example: they need additional HugeTLB pages =
only
>>>>> during the upgrade. HugeTLB already supports CMA for gigantic =
pages,
>>>>> but reserving a CMA pool for 1 GiB pages can fail when physical =
KASLR
>>>>> and other early reservations leave too few suitable 1 GiB-aligned
>>>>> ranges. At runtime, 1 GiB allocations can also fail when pages =
cannot
>>>>> be migrated out of a suitable contiguous range.
>>>>=20
>>>> Yes, that's our use case at ByteDance. Allocating a 1GB HugeTLB =
page from
>>>> the CMA pool is more prone to failure than allocating a 2MB one. To =
improve
>>>> the probability of successful allocation, we typically configure =
the CMA
>>>> size to be larger than our actual requirement, keeping a certain =
margin to
>>>> handle cases where temporary kernel operations (such as DMA) =
prevent successful
>>>> migration. For 1G HugeTLB pages, since the margin must be an =
integer multiple
>>>> of 1G, the extra memory configured as headroom is also relatively =
large,
>>>> making it less flexible than 2M pages.
>>>>=20
>>>>>=20
>>>>> Extend CMA support to PMD-sized pages so their backing memory can =
be
>>>>> reserved at boot while remaining usable for movable allocations =
until
>>>>> needed. This relaxes the reservation alignment requirement and =
reduces
>>>>> the contiguous range required per allocation.
>>>>>=20
>>>>> The series adds an optional @<page-size> suffix to hugetlb_cma and =
a
>>>>> separate PMD-sized pool. For example, on x86-64:
>>>>>=20
>>>>> hugetlb_cma=3D4G hugetlb_cma=3D1G@2M
>>>>=20
>>>> Different sizes of gigantic pages already share a single HugeTLB =
CMA pool.
>>>> Given that, why not let 2M pages also reuse this same pool? Would =
that make
>>>> the overall code implementation simpler? And if it does make things =
simpler,
>>>> should we go ahead and do it first?
>>>=20
>>> Sharing the pool would simplify the implementation. My concern is =
that
>>> small PMD allocations could fragment the default pool and prevent =
later
>>> gigantic allocations.
>>=20
>> Yes. However, the premise is that there has to be a mixed-use =
scenario.
>> I'm not sure if this kind of mixed usage is a common scenario.
>>=20
>> Of course, we don't have much experience to draw on, because on most
>> architectures there is generally only one kind of gigantic page, and
>> prior to this, mixed-use scenarios could not arise.
>>=20
>> Therefore, I think that before the need arises, a simpler design is
>> easier to maintain.
>=20
> wouldn't a shared pool still be sized and aligned for 1G? then the 2M
> headroom stays a multiple of 1G and the 1G-aligned reservation can =
still
> fail, which is what the series is trying to avoid.

If we decide to use a shared pool, I think the current alignment =
strategy
should be adapted as well, it should be changed to align with the =
minimal
acquirement, like 2M.

For example, if a user reserves 1G+2M through hugetlb_cma, then the =
memory
reserved by the pool is also 1G+2M, except that the starting address =
needs
to be aligned to the largest gigantic page (1G). Therefore, this pool is
suitable for both 1GB and 2MB allocation. The only problem I see with a
shared pool is that it may not support mixed-use scenarios very well.

What do you think?

Thanks,
Muchun

>=20
> --=20
> cheers,
> jose a. p-a



