Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB4F3C79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 06:44:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD48F6B009B; Fri, 11 Sep 2026 02:44:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D85856B009D; Fri, 11 Sep 2026 02:44:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9AEE6B009E; Fri, 11 Sep 2026 02:44:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A904E6B009B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:44:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C3941C0060
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:44:16 +0000 (UTC)
X-FDA: 85200542112.07.CD5DCB0
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf13.hostedemail.com (Postfix) with ESMTP id CB4E520006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:44:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=e5KK3FdC;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf13.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=e5KK3FdC;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf13.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789109054;
	b=Lqi4WOUxj6kP0Gi0hyxJakif+BB5SvbDEus0z3YG0NhwBUn1AthKlC4982iSUZTauJPlC2
	V5ddFkv6SKrLjVX9O76/N++Dfuy1y/EhbIQ1C/XoXbxIKsqRZX8FYLXmvEzYd+k/tosAqn
	vZWxJL011pyDQEu0gUsOQYaCtRIvMPs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789109054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t1H50kH3M88JVikkBnDtR3FYrroEvYJwh3vXK+3DDGo=;
	b=O5nFGMvGXJoPcuK1c0sC5uTDHvjCy+3zmgiGY3gkx/hyfVKNpNE+31uNKLKhByCxQTUciM
	jR+lwgl3KMWUNTJ+uH4v8oF5f/aPI1rUoWBt+1jpzFpQAlRxAR7pka3Nj8jn1KVSQ+9Ok3
	Lq3PADFptBu11QukeMSZEL8dwR8o2J4=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260911064411euoutp02d0ac6233c028080fbe5a8a86ea82a729~UMTQGvVjx1863118631euoutp02N
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 06:44:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260911064411euoutp02d0ac6233c028080fbe5a8a86ea82a729~UMTQGvVjx1863118631euoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1789109051;
	bh=t1H50kH3M88JVikkBnDtR3FYrroEvYJwh3vXK+3DDGo=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=e5KK3FdCweoN99A8Aq68AIq6VaEB4V1PFMz1oU40j6tmrjZtbpkljk09HgAdyOtsD
	 2935EV/4FVJMN+kveoaHhlam2sVk8XWZvKMryakPLfwRos8emPs2XwNoi03i2lO1gz
	 Ty+D4A7DidAquXdSvOBUhhp0zsMS5zJiugz4LkqE=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260911064410eucas1p1a59106bb32ffd42bf86506e3b9b7ff91~UMTPcco_M3171431714eucas1p1b;
	Fri, 11 Sep 2026 06:44:10 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260911064410eusmtip10832dba296ae40699d5456b7b7154595~UMTO1e4tm0512005120eusmtip1P;
	Fri, 11 Sep 2026 06:44:10 +0000 (GMT)
Message-ID: <7dff82db-cfac-4c38-91f6-12b542716bd6@samsung.com>
Date: Fri, 11 Sep 2026 08:44:09 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2 1/5] of: reserved_mem: skip init for regions whose
 early reservation failed
To: Wandun <chenwandun1@gmail.com>, robh@kernel.org, saravanak@kernel.org,
	rppt@kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: akpm@linux-foundation.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <cbbe6ba0-5ee2-4597-92b8-3257e152be75@gmail.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260911064410eucas1p1a59106bb32ffd42bf86506e3b9b7ff91
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260818092438eucas1p20115e5d33908e32ef4433cb246da8098
X-EPHeader: CA
X-CMS-RootMailID: 20260818092438eucas1p20115e5d33908e32ef4433cb246da8098
References: <20260818092420.2859026-1-chenwandun1@gmail.com>
	<CGME20260818092438eucas1p20115e5d33908e32ef4433cb246da8098@eucas1p2.samsung.com>
	<20260818092420.2859026-2-chenwandun1@gmail.com>
	<72074a49-2963-4f96-b939-79bf95a829cb@samsung.com>
	<af87036b-0809-4880-b088-545780b4d963@gmail.com>
	<7a964778-adc3-4186-9122-3858bb61c372@samsung.com>
	<7dd9e1c3-ddc8-482e-a560-e8dc4f2f0aac@gmail.com>
	<518729f2-db28-4af5-8ed3-9985c124db3e@samsung.com>
	<cbbe6ba0-5ee2-4597-92b8-3257e152be75@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: CB4E520006
X-Stat-Signature: cfn4kjmhxbh33hza18phhzpatxc5z41g
X-Rspamd-Server: rspam01
X-HE-Tag: 1789109053-936262
X-HE-Meta: U2FsdGVkX198+Nr/PUo3cUwr8DaY30XM6x0l2hCpjcUvoT/GNgSjbqvgTsIcKKXOmRq0Z7iQbcgni8iHEvo/4ZUMxFZeKZQLp1ehpNTSBLqXGOTIkjQ2TRI/kZEmYvC7wLumr9C6iUglkVDszxgB/ognM2aiYl9yac6ckxKzvpEdUgwW6RAKl6G350tkLg95DIEecBKxGZ+wzdwgq/LBt1TafwpPBlBZ6xw9GUy7H68ux9gl43I0nzs3bLWAZ+Hg8A/W3icmHNoAfXA/5Kv42I7e8QbSzhbbMMCFVzvtm4H55YnEz/8oBW0wB7pZ1mWlEH+8K4e6/OwLUXUinpEudfTgudPkdjDBpCbn2Traf+29JXBLbyzzbYSev3J9U7FrKV24aOKRIJPbU6H1eSWBJCDfQqjy2a3ss8Wyp1fIgca4OhZ0GY9RktSDPeP0e0sYgqy0GSePxc54kNGADqZvdldQgwtpf/fIcl5wTtxyFZicYSqcEw6dkCQ1IeqvKhFth8d9YLSqf/Pu9Q/CorQUKE0UWuc2wCyFNZXD4/r5T/rV8OXbyzzuU5nQODTI9a6LValVXBEFRq46s8emm65w1b4Us2La/K6rLwfGlSBVM75WnMFyIOLFD1LAdfDA4JSM5bbVfEdJFEs071sX3dV6Q9cnxy71Lh+IPY18QmiLPeEANcWLES7mxDEJmmwJq218NXks9UHDMUYIrxYDwIw17DhD24pv4lsHslzRmZET5t4RV0JZlEggzn+3sA3OIUCW3jr4E4lkg8l3pOfPKyKcW7/un5zBA9LWYfaZHPiCe2B5iUEaFF5Vwyr8aPRYUxpmHXPenBUlbTMNy9lDL9mWbACY/iJXxpgHvTT954CaI9L4XUSt5iSrOklAeqdnEn0i5p3q/Gr6PZCYCAVpZAjq8I2xrrBwPQcGpsCag69AUDO26fF8w9UpgGeGsXJjlCM52oo7bFpRLAX1sUfgjJH
 Zr07T7L6
 RijsDndyqXXlo2+GZnW4WiBbagc3KWJG+JArXv+40MHnJJTJPmOuFUmRJkOgYdqZBST1iJM8dNDYrczFQFiKCpriHKvhJJQjMsI9zf96nL8/H80SjnAFT9zuMjhETTb0hrCjkD4//7fJWi/PdxT4z2+GiDBIR+Ktd9IRZj24kLIylfpmC7ea+e2sC/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.09.2026 08:37, Wandun wrote:
> On 9/10/26 23:20, Marek Szyprowski wrote:
>> On 10.09.2026 12:55, Wandun wrote:
>>> On 9/4/26 16:49, Marek Szyprowski wrote:
>>>> On 31.08.2026 15:04, Wandun wrote:
>>>>> On 8/26/26 21:14, Marek Szyprowski wrote:
>>>>>> On 18.08.2026 11:24, Wandun Chen wrote:
>>>>>>> From: Wandun Chen <chenwandun@lixiang.com>
>>>>>>>
>>>>>>> __reserved_mem_reserve_reg() discards the error from
>>>>>>> early_init_dt_reserve_memory() and returns 0 unconditionally, so the
>>>>>>> caller counts the node in total_reserved_mem_cnt and the late scan
>>>>>>> initializes it without checking whether the early reservation actually
>>>>>>> succeeded. A region whose reservation failed is then handed to a
>>>>>>> device assuming the memory is protected.
>>>>>>>
>>>>>>> Propagate the error so failed reservations are no longer counted, and
>>>>>>> record the failed nodes so fdt_scan_reserved_mem_late() can skip them.
>>>>>>>
>>>>>>> Recording the failed nodes explicitly is necessary because
>>>>>>> fdt_scan_reserved_mem_late() rescans the DT independently. It cannot
>>>>>>> tell from memblock whether early reservation succeeded.
>>>>>>>
>>>>>>> The failed-node array is bounded by MAX_RESERVED_REGIONS, the number
>>>>>>> of static regions is not bounded by it, so on overflow the extra nodes
>>>>>>> fall back to being initialized, which is the current behavior.
>>>>>> I'm not very keen on such partial solution. Indeed we have no place to
>>>>>>
>>>>>> store the result of the early init call, but we can check if the given
>>>>>>
>>>>>> region has been earlier marked in memblock as reserved or no-map in
>>>>>>
>>>>>> fdt_scan_reserved_mem_late(). If those attributes don't match the
>>>>>>
>>>>>> region can be simply skipped then.
>>>>> Considering the later patches that reject reservations for overlapping
>>>>> nodes, checking the memblock state in fdt_scan_reserved_mem_late() may
>>>>> produce false positives.
>>>>>
>>>>> For example, if region A is reserved first and region B is a subset of
>>>>> A, reserving B will fail because it overlaps with A (in patch 02/03).
>>>>> However, during fdt_scan_reserved_mem_late(), B will still appear to
>>>>> be reserved because its range is already covered by A. As a result,
>>>>> B would be initialized even though its own reservation failed, which
>>>>> is contrary to the intended behavior.
>>>> Imho the overlapping reserved regions are some kind of configuration 
>>>> mismatch and it is enough to detect them. fdt_scan_reserved_mem_late()
>>>> can first store all regions to dynamic reserved_mem array, then check
>>>> for overlaps, and only then initialize those, which don't overlap and
>>>> have proper memblock attributes?
>>> Thanks a lot for reviewing this series.
>>>
>>> I did try this approach, and it looks clean. The overlap check works
>>> well for regions within /reserved-memory. But there's one case I
>>> couldn't make it handle, where it seems to still produce a false
>>> positive, please correct me if I'm missing something.
>>>
>>> For example, region A is reserved before /reserved-memory nodes are
>>> processed. A is not a /reserved-memory node, so it never appears in
>>> the reserved_mem array. Now region B in /reserved-memory is a subset
>>> of A. At early reservation, patch 02/03 rejects B due to the overlap.
>>> But at the late scan, B's range already appears reserved (covered by A),
>>> so it looks like a successful reservation and gets initialized.
>>>
>>> The root issue is that the late scan can only tell whether a region is
>>> reserved, but it can't tell whether the reservation was made by
>>> /reserved-memory node itself or by something else. Maybe we still need
>>> to record during the early reservation stage.
>> Then maybe it will be easier and cleaner just to add a new flag to 
>> memblock_flags (see include/linux/memblock.h) and mark each successfully
>> reserved region with it? There are some spare bits there.
> I really like this idea, it's cleaner and directly solves the
> "late scan can't tell who reserved the region" problem. Combining your
> two suggestions gives a clean and simple approach, and I'll implement it
> in v3.
>
> One concern: a reserved region carrying the new flag won't merge with a
> reserved region wihtout it, so memblock.memory and memblock.reserved may
> end up with more regions than today. When fdt_scan_reserved_mem() runs,
> memblock is not allowed to resize, so if regions in memblock.reserved or
> memblock.memory are exhausted, panic will occur.
> The default regions number of memblock.memory/memblock.reserved is
> INIT_MEMBLOCK_RESERVED_REGIONS, it can be raised if a platform actually
> hits it, so I don't think this blocks the approach, what's your view?

When reserved memory regions are not contiguous, the current code will also
trigger memblock split on each allocated region due to setting the
no-map or reserved flags, so setting one more flag should not make it worse.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


