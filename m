Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF418F531C1
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 212106B0089; Mon, 13 Apr 2026 14:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C2696B008A; Mon, 13 Apr 2026 14:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B1CD6B009E; Mon, 13 Apr 2026 14:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EEE4B6B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:32:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC76DB75F3
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:32:21 +0000 (UTC)
X-FDA: 84654377682.15.90D5136
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 01008180007
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:32:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IVNfHTbB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776105140; a=rsa-sha256;
	cv=none;
	b=v/xwVyyR/SDgmfBJBUBnDbYZGV+W00aDndsFbezgf6hJAQLZ8AYQGib9Dn9/65D0atZHI+
	1TNSK77xA3h4exPQBMdYXbiQT9laJC9mWzUVu6h7ZTJ1SFoARMr1/A5Jye325pUGW10hch
	SLXEeR+PV5gsQwKFFs3/dPJdLQbNxEo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IVNfHTbB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776105140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NgP/Vv2MjQyTGsgzRJ/wBBPGSakZERPOlh0wWLdcVZ4=;
	b=t/YuLy6jaVv8KYj7INLeRYTRYhpE6kzXyV/A3E6OfGL1XnuXjSYLtSWWR3UFxYqJfnNGxX
	rRKKbURUj+unLk7SP8xiiZ627Df9Kl40Y6dRo/V39y0ht4gOqXNkziUGDWAptNWeZ+1A+n
	Wwwd7f7E66K1jkmK/v0otoEM8npOz6E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 320116183B;
	Mon, 13 Apr 2026 18:32:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C82CC2BCAF;
	Mon, 13 Apr 2026 18:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776105138;
	bh=EvxSafiBWABrGah99HN0FwITRI/21BtvzrpeZ2gtImA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IVNfHTbBPdeNKO6fGf9PMgz2JYDGmEN40iDFS9drIkBgKY/BjyJU8cx3jqAgXJi1s
	 phtWvNieJ6dW5qnOZgFUFFr8cgCA1BwCpd5Q54iUf/H60Nftae+WbZzb52hmRwblG5
	 z44DNFBsSSzxraEOk/qn7aPM4gBm/+e5Q4DrlrBzzt8qwN/RVWuQSG+ABIRafe6Rcm
	 Wpj5R3ZFqXgTWhUsFNP56EMv06Jhbu6LETT4xFDyomkTzRswQK3kLiwKq52Ru8bfhN
	 Ry+6mMtYAjkMC+yfBfr7r7KsmLfKbfG9v4S81QebzTH0IEL9k/WzpZbWf0vTb+V9a7
	 1gU3BIO3J0ADQ==
Message-ID: <534ed892-a6ab-454e-831b-e207930c35cc@kernel.org>
Date: Mon, 13 Apr 2026 20:32:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/2] mm: make lazy MMU mode context-aware
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1774420056.git.agordeev@linux.ibm.com>
 <de89fd353a8dcd5e3bef4d91e9b6682d132ed9a0.1774420057.git.agordeev@linux.ibm.com>
 <44dd86c0-1845-4dd9-b4b4-2cef6d1c6357@kernel.org>
 <e096e88b-f1fe-44a1-bfa6-451eef028203-agordeev@linux.ibm.com>
 <665a19a0-47c2-404c-bd2b-482ab51b8f64@kernel.org>
 <896b3d93-8e60-42e2-b8bb-d3d4e8c99927-agordeev@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <896b3d93-8e60-42e2-b8bb-d3d4e8c99927-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 01008180007
X-Stat-Signature: 6a7ffzmgb6cfdbbw43c38ihkt4et1wss
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776105139-882729
X-HE-Meta: U2FsdGVkX1+NCogKQBTcC34bu1bEoW1owrdeyBmlzHjLu5zDyFiQuI9YXYFYvjanUoA7RhatPKQoSIC2xlGUYMCiVwPiMa8FSWqGRHHxoZoPUoRNzq3JVSsGMboEJQBCFukdb2/VKyGTHfeAioMlQ78Hfl1IJDILbY/9lXOa3vyoU8E9Niky0PJj9A21GhOpgnRULW/EIFd7ZYnlF32Cns4WkpHyA+tukVM1sIHBnAehehnLboF+EFGj68owpW6aODZGSOFCLHxdT3I1yS6cchevVLZv/cX5CoUbC1XmYkoB0QzWcKCmE5xl31+cej1zzr9GN1rTylwiYcy3VU7AupOIIFVWh7HiXKZ821ChkfwqHoa0ihL+OQu3wQOKMOjW/JG4ph8n4giN463yywUZeXvE9S4V8XLdYySmsr0ByeTScCOIYyxEfs6MLxTRjUN+vTJCOeiLAbrxDQabebE1fc4BR8vMdOnedAOq1dxJVb35izE7MhYqiGzWC5E0mILSko4IA6bVKhIgUjoWvxulrBuNKD88PPNO6wOC3krFufC6ICn5MKkrH/WbLJQC6sUeIw3x2ClINA7r5YDLz7kRv/EXxNgK8/DchBIkKbFsahMK+G0IFn3/zfT9uo0ji72dTbpxSboNDpOmy78QivtY1X2QRmOD3a1h0MH0MAkZSWliUoKXSYI+4EdE87mqJSZP2k3T5Zks7QHO/Cd9dX47+dDOpbzgyHwb+rIci0WX5HeglnKVPMYiQsTmA4V1CS799eemylZuGtG192wuv/IBhRU5gx96kXNerUhBQq0/4ImWIfNDV8BsMNMeWDp99e5uK0AI3VQ0ngGcsCMkf2SoXGlgJYkteR2+FoT8V91xn7uQ3paD/Q7ZEaz3KIB11P/Y2FRm9lPwbydptzKtkAT+tDzZdpzAfUlkoErFWaTkUNxE7sDRWUrQNBNX7jlVQXVHD/phKItY0GsOZ4fozJj
 K2hzuzFE
 WNhd6R5d8RJAgpyPWcMMJkioUnVODB+GVY21+bn7NSA7dlwtrA08YvuJeAF+oY2lselYxFKz+OyYV2EZXaqyC49cxLNANdEMOuu2yVNboA1im/xqMCK/lzVqI7gQRa7Yo1/mXgRwh7sYQf6ujSG4YvXh3SaJH8G4RB8Zr+sbldBuI0PAkRZxApBOXn70/MXnKWyZ94xaOhF4PQPZ6J+UoNseRnCjwBCx09vwPFePjZUKKPGAMCC0el6q5I+hjUSJFpEQ2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 15:43, Alexander Gordeev wrote:
> On Tue, Mar 31, 2026 at 11:11:22PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> The only implication is "only this address/PTE range could be updated
>>> and that range may span one page table at most".
>>
>> Probably phrase it stronger. "No ptes outside of this range must be
>> updated" etc.
> 
> That turns out to be bit more complicated. The below cases do not fit
> such a strong requirement:
> 
> 1. copy_pte_range() operates on two ranges: source and destination.
> Though lazy_mmu_mode_enable_for_pte_range() applies to the source one,
> updates to the destination are still happen while in tha lazy mode.
> (Although the lazy mode is not actually needed for the destination
> unattached MM).

So, here a

  "No ptes outside of this range in the provided @mm must be updated."

could be used.

> 
> 2. move_ptes() also operates on a source and destination ranges, but
> unlike copy_pte_range() the destination range is also attached to the
> currently active task.

But not here.

> 
> 3. Though theoretical, nesting sections with interleaving calls to
> lazy_mmu_mode_enable() and lazy_mmu_mode_enable_for_pte_range() make
> it difficult to define (let alone to implement) which range is currently
> active, if any.

Right. I assume you would specify the source here as well, or which one
would it be in your case to speed it up?

> 
> All of these goes away if we switch from for_pte_range() to fast_pte_range()
> semantics:

I don't quite like the "fast" in there. I think you can keep the old
name, but clarifying that it is merely a hint, and only ptes that fall
into the hint might observe a speedup.

Could performance benefit from multiple ranges? (like in mremap, for
example)?

In that case, an explicit hint interface could be reconsidered.

-- 
Cheers,

David

