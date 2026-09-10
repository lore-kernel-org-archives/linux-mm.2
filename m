Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F8EAC79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 15:20:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C6DF6B0093; Thu, 10 Sep 2026 11:20:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E676B009B; Thu, 10 Sep 2026 11:20:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF7666B009D; Thu, 10 Sep 2026 11:20:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D20D76B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:20:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B5648A05A5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:20:35 +0000 (UTC)
X-FDA: 85198214430.13.A47038C
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8D4301A0007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:20:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=o+PGVAam;
	spf=pass (imf19.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789053633;
	b=Nh+oFlHnAhy3E5IGsumZESMdvA/SWBnFXm8bE5qJocnDufdCHgZZdh7oswep0g0W0cBWe3
	RJZyt6gdS66sMa7f8hU/yJMRTXAMnVi8HAnjIXnNlUW42MOpv7kJIMkDi2pGVNftslLLyU
	ZoConLgdmwEd+Eq+Hl35kNoK5D0uFDg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=o+PGVAam;
	spf=pass (imf19.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789053633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=izFHd1RA+/2Fh1sAs5H355El9G+IR0JNrZBtgpSNdTU=;
	b=J3m5GBmzVUnw4NQvF4BGMFL/uWoLmhi9adbNWHxcvaIrNXIuBY4crdCU+XkyR8/LfswIxY
	z7wsn3Iz17nMm8u6qp6MseD4nuqgd1XEJqlThdwxU5YTz5hbDLK15U4QwEZg4XjPWBa94A
	B2KAbfNN/b98cR3WhiWAW+S5lxMLe3Y=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260910152030euoutp013b5c7a443d917ed3faf35ff3734e5835~T-sxHQFbQ1880518805euoutp01U
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:20:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260910152030euoutp013b5c7a443d917ed3faf35ff3734e5835~T-sxHQFbQ1880518805euoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1789053630;
	bh=izFHd1RA+/2Fh1sAs5H355El9G+IR0JNrZBtgpSNdTU=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=o+PGVAamrGuZJIq5ZBtsHzbopMnELdgTdEygVYagjfRGthDID706s0UX1ntU9c7UA
	 3D0tiAV2Dv9Xh7ql5krC4ypxX4lbDHSGlyZhGgwzg/7GkedYTTABE7gYtyDJiD/2+W
	 hmYABDL8NDG99JuHrtdPgaByzEWOmsvhHyEwoXX0=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260910152029eucas1p10ea2e109779b1e8cd23a832adcbbd0fc~T-swhAOzC1238912389eucas1p1U;
	Thu, 10 Sep 2026 15:20:29 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260910152029eusmtip1fa72d122c1c1cc8d3fc529180af1982b~T-sv66MgV2099520995eusmtip1O;
	Thu, 10 Sep 2026 15:20:28 +0000 (GMT)
Message-ID: <518729f2-db28-4af5-8ed3-9985c124db3e@samsung.com>
Date: Thu, 10 Sep 2026 17:20:28 +0200
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
In-Reply-To: <7dd9e1c3-ddc8-482e-a560-e8dc4f2f0aac@gmail.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260910152029eucas1p10ea2e109779b1e8cd23a832adcbbd0fc
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8D4301A0007
X-Stat-Signature: 7ss9pgajuthfgu8yb7ej9ys1daygwjt7
X-Rspam-User: 
X-HE-Tag: 1789053632-635582
X-HE-Meta: U2FsdGVkX1/qwLdlboj6nOiYR9ehNQw1c8fY8GY2eGo1a5QEPvd5rSFxwkENsjUziBCbwtLvYv1q1MzEly377QVYMi0BGVuYBUPyxMSBjuJYkQC/olTa0nhiHQG71+wBbE7mlOPZUF+eQQL+OmxNThAkAajHRUC4onRXtMqvduBFfoM1qLy0E8if5dSgZp7NixnsbrOMnp5M9KlrKfCVn6Qcc1KekbOb6CkidX4HYEUS0bEtWO1fiO/6je5+K2GxgrFhdLW743QWrRJ9yoyEmGxFrnoGCWMrQ/0txKIBu99G8vUNzvgZyzaI6cCMd4IFCQdjnQcpc19PoZmzoPcOIZfzyJ5NBdSMAX1rXwl6AcpaX+yqOhsMj1q/qWMbPqhTj1eMFrbXkvIbNRSyogy9SC3Nm1S0f5nc22uR2vamS7LFFIkTCLo6w6zIBQyI2aBmQ4ZHMYsjApkSxfKSShkHFARZUDizuJzTAc/EpjJuYcY1mzWKxE5WXIIFKiH8tszdH7YrWZZ4VFENJg8shrhtGw5hJvz/+PtBG7cFd4n4c2+g19g6dIIZXElshUzLvlXPHD+moRfU2scds2e5V8gJTFWG6iOsX5htRADLRj3KpISXyNmZjkzLc6Pce5sFs8AY3rpHNr5aOvWO1sjrQZJADtIDGCqSYsu5xWJvKy8GLquVav/Ea46ZIyBwLruHb9Cpe08PvpMBwg7OC4W7GiXnyUSTIoe2oh1soQcUOsTJNWbXH3+oU423LLyIaGCMDYEoCjLKGztCmRJJAn9+vRZQrQxUwgPhYCyCj9MPLvX8E7bVaK9lu2I3pnF9Ab1IeYGzY/RyI0LbDZKW02YAEhWE4BX5E/FncqN/q5NFf0dMIEfyWf+HCULcrlwAVGyv+ikJmr1V5uF+xALsF553ByNOXdEkX5e8i9a6nVevcBN+YN/o3VC/pNMYQb+kdYvhU8r1OfYIMxZrz7JXRA/vLsn
 etV4OlFp
 bdd9hmHcMzxT4qZSsOLo4P5zSMTti1ssP2r9HJvqfF+UL64dsSQfY4AC2K/A+7zTmSZHK0xogYxbOjFFYLblb0NrcOvvSqmOayE0ANQBuwjLPsiPbtF6Y71ZXKt2kJuTzCBjN6arnAe+NNMXADPDLUf1MIq1WXU69uLrLsI1bQ7/1lVN3YQl8gXR0qA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.09.2026 12:55, Wandun wrote:
> On 9/4/26 16:49, Marek Szyprowski wrote:
>> On 31.08.2026 15:04, Wandun wrote:
>>> On 8/26/26 21:14, Marek Szyprowski wrote:
>>>> On 18.08.2026 11:24, Wandun Chen wrote:
>>>>> From: Wandun Chen <chenwandun@lixiang.com>
>>>>>
>>>>> __reserved_mem_reserve_reg() discards the error from
>>>>> early_init_dt_reserve_memory() and returns 0 unconditionally, so the
>>>>> caller counts the node in total_reserved_mem_cnt and the late scan
>>>>> initializes it without checking whether the early reservation actually
>>>>> succeeded. A region whose reservation failed is then handed to a
>>>>> device assuming the memory is protected.
>>>>>
>>>>> Propagate the error so failed reservations are no longer counted, and
>>>>> record the failed nodes so fdt_scan_reserved_mem_late() can skip them.
>>>>>
>>>>> Recording the failed nodes explicitly is necessary because
>>>>> fdt_scan_reserved_mem_late() rescans the DT independently. It cannot
>>>>> tell from memblock whether early reservation succeeded.
>>>>>
>>>>> The failed-node array is bounded by MAX_RESERVED_REGIONS, the number
>>>>> of static regions is not bounded by it, so on overflow the extra nodes
>>>>> fall back to being initialized, which is the current behavior.
>>>> I'm not very keen on such partial solution. Indeed we have no place to
>>>>
>>>> store the result of the early init call, but we can check if the given
>>>>
>>>> region has been earlier marked in memblock as reserved or no-map in
>>>>
>>>> fdt_scan_reserved_mem_late(). If those attributes don't match the
>>>>
>>>> region can be simply skipped then.
>>> Considering the later patches that reject reservations for overlapping
>>> nodes, checking the memblock state in fdt_scan_reserved_mem_late() may
>>> produce false positives.
>>>
>>> For example, if region A is reserved first and region B is a subset of
>>> A, reserving B will fail because it overlaps with A (in patch 02/03).
>>> However, during fdt_scan_reserved_mem_late(), B will still appear to
>>> be reserved because its range is already covered by A. As a result,
>>> B would be initialized even though its own reservation failed, which
>>> is contrary to the intended behavior.
>> Imho the overlapping reserved regions are some kind of configuration 
>> mismatch and it is enough to detect them. fdt_scan_reserved_mem_late()
>> can first store all regions to dynamic reserved_mem array, then check
>> for overlaps, and only then initialize those, which don't overlap and
>> have proper memblock attributes?
> Thanks a lot for reviewing this series.
>
> I did try this approach, and it looks clean. The overlap check works
> well for regions within /reserved-memory. But there's one case I
> couldn't make it handle, where it seems to still produce a false
> positive, please correct me if I'm missing something.
>
> For example, region A is reserved before /reserved-memory nodes are
> processed. A is not a /reserved-memory node, so it never appears in
> the reserved_mem array. Now region B in /reserved-memory is a subset
> of A. At early reservation, patch 02/03 rejects B due to the overlap.
> But at the late scan, B's range already appears reserved (covered by A),
> so it looks like a successful reservation and gets initialized.
>
> The root issue is that the late scan can only tell whether a region is
> reserved, but it can't tell whether the reservation was made by
> /reserved-memory node itself or by something else. Maybe we still need
> to record during the early reservation stage.
Then maybe it will be easier and cleaner just to add a new flag to 
memblock_flags (see include/linux/memblock.h) and mark each successfully
reserved region with it? There are some spare bits there.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


