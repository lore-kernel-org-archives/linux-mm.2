Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61E49EA7188
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 08:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EAA66B02FD; Sun, 19 Apr 2026 04:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79AC76B02FE; Sun, 19 Apr 2026 04:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6896A6B02FF; Sun, 19 Apr 2026 04:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 55B526B02FD
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 04:20:12 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD45EBA466
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 08:20:11 +0000 (UTC)
X-FDA: 84674607822.19.95D356B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id F00EFC0009
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 08:20:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jY1BPD2l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776586810; a=rsa-sha256;
	cv=none;
	b=u1lz6qurdNF6IO4berExgPdrra/d4mgC1EMEVP5Oj8Qk9i+AD1keE1zGVeZbHvVOIj2Itx
	qBW/b25Q2z6+StIpmKhAoI+8jOlZFgaxYgxVSd2/8Tkp4lHAxNJLeXtQ/h2/POQYt1RoL6
	23P9ffX51hufk/9jhgDdMoIY8DaCfII=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jY1BPD2l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776586810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wYQ9SL0cxa+vrV2T6FOQ8EMQsMy6DaMa6Vfh61bL1vs=;
	b=2y+fJJAOm6eATvM3RAKinM7kOgnih9Cei7LrrxlTaCTHaagvt5CjTLgnoaXmwHC7zhjwLd
	snfqx8MsdINUgxKP8JYhWPTfYJJOafw8Y9JJws0lIe4ugJM8eQSf86fHGL2IeApG3kpv/l
	7cGxLwtKTCnrQ7EaAX/PMzxKf5ZXlxA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DAB464450C;
	Sun, 19 Apr 2026 08:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0B7C2BCAF;
	Sun, 19 Apr 2026 08:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776586808;
	bh=ULzAcQ+a5yvU6pSydPbcp5Zrd7MaFUBLpohDNl0zto0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jY1BPD2lU1Iqz7fd/hrVI4VR2mnaRy7YSp0qiFqQOF0egxnj5OfsXl3VHc08ncjvI
	 asjBFqyyeELe0U0CCDnkgUJR0mODASwcvBUzKoES8ge/b+a1qZvz3iIetDqro/3YDu
	 Zg02sSy2I3l4Su32OyEciZ0z5J59oy8kplSRsUYomBpiTdD3/Q1nwPqfACTsEAVV4p
	 XZf2q3y2Jd1WUC5Ufo9hi9pJ9nEb1SUQnEOr/PpZKBHbOxRBnCR9+gax7lR7xAtGwR
	 Z+POE2aqz4butePJg6YNOjC5/d+6Na02UjwzpBHf2MdIdClFBq6oINoybXTMYCZ17B
	 JlqfByBVk1D3Q==
Message-ID: <7b983108-4846-46ce-b9f5-2aef319c00dd@kernel.org>
Date: Sun, 19 Apr 2026 10:19:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: prepare anon_vma before swapin rmap
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: ZhengYuan Huang <gality369@gmail.com>, akpm@linux-foundation.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com,
 zzzccc427@gmail.com
References: <20260417011606.1089985-1-gality369@gmail.com>
 <66f67e51-819b-4c60-9f61-170db32362a2@kernel.org>
 <fb80d953-93de-4ce3-80c6-15cd53dd956f@kernel.org> <aeNP7mtx878gynXS@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <aeNP7mtx878gynXS@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Stat-Signature: izb9wsucms4sz5mb4doebopgcgud6enc
X-Rspam-User: 
X-Rspamd-Queue-Id: F00EFC0009
X-HE-Tag: 1776586809-914914
X-HE-Meta: U2FsdGVkX1+0A1LoAxlMkFsZKZfbqvhLRcmteSnJ2C8zXA4Ynfkdizo7M4cQNQ1YXb5xosStvq73RpNjJ2jCX0ZNBr2XsK8/q9HDZ3Wsbl/ZnzMJKvr8bHLcGAHr/OmJ2tFAVgZrfxI6i6onfMjw492SKrLjP/71dVZHRGXtxrd8i7XcfeMl4LL4oRE5kTjKSVQ6gRhTkui7mKniu9BHSv2SL1VMNlwqlWDsKjPsEreef4fGkfcpHGxL3QF087xnI6uDbWYNxJZvOAMxeEbNPSm9O7RLUyZd6zlD4puG37vumfOVKoAWtPD2IHsrGBH41NsVbuDTHtabYPNlLzAZYJ1vp2I53xpUYa8ociC27c0JzmRBk9yYVQQ2GHvLxTMwuiZ6x5xh8MkY0EiTAyzBQXMgjWGBNeDIfNZi74esX3MFvMDrkiBWVSHa6ol8CIp1zRn6jxS0BH9WynTn1axNnDdWpbI9OdprHUanTdzMNPyTD17DSmmydyiHCoyQ66BCisfaDcYXklrSI5XnNI6eQ1eenql2RT2OWi0cgaBpuYCBbEN4suFFYmSpoShS4185MnA20oHYueDv5Yu52XwMX0WUALdoDQrT0vfTyXDcXerjIoIYq7MLO2kkuCAKrAFKgWIz4W4bN/bjjigwSpFfMT8jGzjKqgGSgBrgGctXBTuA+ru/5z28LRU0H//6jaQWCo5tJkn4ZpVQFPX0lYLVNIHsYWvDbX+PViWjxohmhoBIe/yneg/jTNkr2D6d4dCP4H5ZyW6G3hhwjK5Lz1pUkPYg5wZmczIVy2GJ6s/6oWoEcFoKlYU8S5jEq9+tKnFnZSBo/wPuyndmAMD8ppWNnFE1cH+Pk43NCYcmjNK/5X69qfQj6B4U1ev9yWOBtC2kmQxOPpsJ7otb8+kBGBECuLR1U/7h1083NOsG/+pcVJ1eqB1OpGj/wIroYOcAxwf7t5ps+zsOjNNk2AyJLCy
 /vC0XRoO
 pqBUxdHwHH082kk5+bOn0592av9Z2pSsF6zTEr2+HXJF3FTlW/8t4KHaHtEkP7z4jA6dsfzqxYTs0dWhZEBDV6dd2jNgJWd8pS3C6RFkHF+UACG9iTB64K2s2iezprxo9LVGfawk4HpfSmxW/CCaVKyrHzTOdG1+cCaQDxr833sCNznIql9PRJeEjqOQLxOVnWNf7cpErAGVY1YIrh4RMSyTxPcqHx5qJ2T5rMiGgKuvhagaNs0AaoL+rdM25H2xEJMe0NIIp8qnjmMZ1Vlob4Ip/0GsD/EA0Nv9wNSIE7XIcxyz+79eF1AwflLjq8719CvI+g3eEoaPOPXc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/18/26 11:35, Lorenzo Stoakes wrote:
> On Fri, Apr 17, 2026 at 01:57:59PM +0200, David Hildenbrand (Arm) wrote:
>> Maybe there was a scenario where we could have lost vma->anon_vma during
>> a merge, resulting in a swapped page in an anon_vma.
> 
> Unless there's a bug (and correct me if I'm misinterpreting), VMA merge requires
> vma->anon_vma to either be equal for merged adjacent VMAs, or one or the other
> VMA to have NULL vma->anon_vma, in which case we set vma->anon_vma in the merged
> VMA.

I think you didn't understand what I was trying to say.

The reporter claimed that it happened on 6.18. Nobody knows on which 
patch version (stable tree?).

I was wondering whether your fix

commit 3b617fd3d317bf9dd7e2c233e56eafef05734c9d
Author: Lorenzo Stoakes <ljs@kernel.org>
Date:   Mon Jan 5 20:11:49 2026 +0000

     mm/vma: enforce VMA fork limit on unfaulted,faulted mremap merge too

that went into 6.19 might have resolved this problem.

Your fix stated "allow an unfaulted/faulted merge with a VMA that has 
been forked", so I was wondering whether that could have resulted in a 
situation with anon folios without vma->anon_vma (losing vma->anon_vma 
during the merge).

But I am not sure if 879bca0a2c4f could have triggered that. Are you 
aware of other fixes that went into 6.19 that could have fixed such a 
scenario?

-- 
Cheers,

David

