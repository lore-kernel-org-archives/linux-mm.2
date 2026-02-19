Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDC22E9A053
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 17:10:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A0596B0005; Thu, 19 Feb 2026 12:10:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36AFF6B0092; Thu, 19 Feb 2026 12:10:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26D836B0093; Thu, 19 Feb 2026 12:10:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 13D216B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 12:10:06 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D4A2B13B602
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:10:05 +0000 (UTC)
X-FDA: 84461843970.29.F782A02
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0414A1A0002
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:10:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZUZLbyBV;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771521004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wwaQ7yjoaWHQevPaYkB/eQDdXL4o6cmVMdId4TDRCAg=;
	b=hd9qbFBNl/FMBkwS0Uwuh4jHgD/YxE2dPDoop36l+NJU2BHC795ptLE+xczHrbPn63QYUa
	K2sCrGr95u4nO2CPysUgoWjfZh/1Jsjo5n3ywJAeQ4FzTjOochi06JX+j5ljEcIVufVYuX
	Mo+bKlZ+xggi3Cw/AUcLMFE5xrlEehQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZUZLbyBV;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771521004; a=rsa-sha256;
	cv=none;
	b=Iiugg7XP6bl9h82hWZvi8IVABWZLWVLkahLMV2UhNIVF1VLBe2Wx7TuXs0c5R7hR6tHf+k
	AW3gBvOMVxIxpAFp2d3d5s67hxXY5BQYZOW95o45+X0eB2Nk/KtVe0TmQUFjIGdhj6zqYb
	oRfn3R/mojpJ+OQYAyAWIuKhmzQFTA8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2397A42A74;
	Thu, 19 Feb 2026 17:10:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C850C4CEF7;
	Thu, 19 Feb 2026 17:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771521003;
	bh=VXIRoiZa4jvIqeI1ftuH5/J1d1U0pb/RhIyVitMKT4Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZUZLbyBVOmTvJz17zADJZeklHEKvkuHDJE22EjVcOppXxS1tA78d6OcREqNbQ4kPS
	 KfSOX4/rGHgmeZ4Cxkn5d4dXAk3PafftptUnM22ylR6hIKQnjGUgPoEB/uSjSMJ70k
	 YAEBFJnaldZtQkMIVhq2KEzX03EYQtq0QUSq4ano34UJk4xzFWS4BoTOTMgn83X52E
	 bDSXjK933FZ1gU74bqpJ3Z25Etp2v3Fl17eiv9an0w4WTEt13dmhY9mYpg9HQeU/aw
	 BgfaBNDAxQtgQfCJ0Qcp3FC/NfZFOwq9InzD4to+84wHTKFm6SSfCl8UGIFOL6UVCx
	 rZ2kElglUF52g==
Message-ID: <4bdc9327-aa00-4d42-b883-7f8ef0ed5c3f@kernel.org>
Date: Thu, 19 Feb 2026 18:09:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Beyond 2MB: Why Terabyte-Scale Machines Need
 1GB Transparent Huge Pages
To: Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: Usama Arif <usama.arif@linux.dev>, willy@infradead.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, riel@surriel.com,
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@suse.cz>,
 Lance Yang <lance.yang@linux.dev>, Frank van der Linden <fvdl@google.com>
References: <540c5c13-9cfb-44ea-b18f-8e4abff30a01@linux.dev>
 <3485c8c8-9bfc-4725-885a-626e79d0aebb@kernel.org>
 <aZc-8dMBz1XCJI3n@cmpxchg.org>
 <A4DDD3A2-104A-42BD-B174-676012166BEC@nvidia.com>
 <aZdDjA16yQYV9csN@cmpxchg.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aZdDjA16yQYV9csN@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 0414A1A0002
X-Stat-Signature: a1n83wzbw55xqsjrf3cuoi4cq96c6gyo
X-HE-Tag: 1771521003-792163
X-HE-Meta: U2FsdGVkX1/5kSJvTeeFvWbBjgkgdt8PVHGy9Lyk91VfYeG/2AQmr5nRjuV/sav9djuEvnxnj/V3pte+i4dO4lNtBxHDYCn3G0h3Q9/adae0NOzsfxTA6L4r/KxFhzogzoM88cLkittKeVuG71iEjfupFZSwaJZiX2Pq50UXqfuGcyznYUaRYCZbxHh5qYl1lWnvlS/dw5CzLNO1/tygjKBgJQ1Lzo8QXei7xhuzYe81f+2ndMIn2eYpOAjCmeld60/BA7h1DXhV6aPFdSLUpkHCDf/pfl6KriZGSfgBXVaAR4diw9s7bWSUH0bYxfnSw9KzNT8GRwRRlzXzMcLD27gMJ4PTlzCC8q+QGCVy9xAYZrNiOQQrE8WX9AlVBxoVg1uHllN80WxoX9mVnfnz+PHTgADHgRzfgGhlPYlTomxycbALY9SJPuWgo3M1wb6yi1jwrEr2vBemZogBaUO4BMgiUmxh92I+P8ESCEEz8Qo3JzNP3CEmEHajmmFOZAX8KEYrpWdV6lTdbCWphWpikTpCNMEdNOwkRkLg6xoT8xWvZ9n0xOCDwOIP+2Iti/hjZ1XDEFduIW2hX85Xfs651Jydj0nGF+Et4ipjoqER77DWShXtrUg6PKVaXgC9lz0Eb/FKmg8Fien9IX0vI+F+KZcXxl1esAq1fd6oUQQPnDcAKPfW/ojd6CnTWg36UnvROeF1qNQ+5H4YRlzi/yijC1HcKU4BrEwIw8piCtKSgOS5+p0SugQbL7XQ3Fc5OiItKUmGwL92tEZiqHuzvROqLVYaf09LAy2m3SR+4YQhysIhP/8D2jYP8K+DkM3LU7POnqeSZwU+IapKnNRr2cKmJq6L897EDYDy+dT27rglokFE4mMIZ4A21IyIuuLWavhKF174Ibe2h1Bj5l1JFvpMIVYlP1BwH0hD/EsiZL9kCl6yjTSLaXBhzKltKzD8PV4YzBsenH3RB2UtG6d3gkw
 STG8WR49
 a7bF2C9rmi9nyEU4DfQ4R6kqj7VvZJo+JhZZIs6tWblssLFm6ciZWAJev87M0WGyHB2k2e3JsIoXJpYXA6dpy4g87f73gfKzUH2Q8tIY0njC2qgBCMALllzI69YuAQGa94ccQSCSdxxQfzgxihF38j8ogPT3TeC50nBOCroMpT6dFD1TdMq42EBum2AK6mzNxltOI+mkd1e/dZcnV7ASpDRqOhVBZFOVzJR816PWumhUeNw0lU4N6tYNzsg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/19/26 18:08, Johannes Weiner wrote:
> On Thu, Feb 19, 2026 at 11:52:57AM -0500, Zi Yan wrote:
>> On 19 Feb 2026, at 11:48, Johannes Weiner wrote:
>>
>>>
>>> With TLB coalescing, there is benefit in preserving contiguity. If you
>>> lop off the last 4k of a 2M-backed range, a split still gives you 511
>>> contiguously mapped pfns that can be coalesced.
>>
>> Which CPU are you referring to? AMD’s PTE coalescing works up to 32KB
>> and ARM’s contig PTE supports larger sizes. BTW, do we have PMD level
>> ARM contiguous bit support?
> 
> I'm not aware of a CPU that will coalesce the 511 entries into a
> single one. But *any* coalescing effects will be lost when the range
> is scattered into discontiguous 4k pagelets.

You could of course migrate to larger folios, not necessarily 4k.

-- 
Cheers,

David

