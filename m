Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDCE4FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE8E36B008A; Mon, 27 Apr 2026 11:49:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC1256B008C; Mon, 27 Apr 2026 11:49:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD60E6B0092; Mon, 27 Apr 2026 11:49:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ACB636B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:49:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8FF441A0AB2
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:40:46 +0000 (UTC)
X-FDA: 84704748492.11.673F519
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8D348180012
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:40:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mUWPmibx;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777304444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uaa2e3DnCasQRCrZwfQTTSZVmln55CWbOKDvgAW8yoU=;
	b=31rfFuImUw9Zq+m5BkrOU+KuwebaTG7eoMuzR89jhHNdtDoddgkWOGYniI1Eon+NZpkoYP
	SffebVW9nG0QsuvPCRzw9Q9I1wwh+/RArC07O/JXlYdE1LnQ6IfHETcEZBpihIA/DV1bF7
	iYPornZpKAp96nnHD4IGXGsLkE8dFMg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777304444; a=rsa-sha256;
	cv=none;
	b=4T8m6i0nlgYe0UNu0O5pMvxBcI3kp1rZePRj4UD0jL50MTEcTINXytV9STUzqoIBJ357ES
	chz9KgNTodJghgMqnPCy2qxOFy9u5gBBxE8Gy8U6ieZwGsy7yNXUDYR4xJPwKHPdT+sVQz
	IgCKvlavYpY+0XoUlF0ZFxGWN/KQds4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mUWPmibx;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CF0541A70;
	Mon, 27 Apr 2026 15:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E84C19425;
	Mon, 27 Apr 2026 15:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777304443;
	bh=c8ztL5UJrnKIx/gGq3C03wQiSe/tIOB3pUyZvRG+qEY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mUWPmibx6XGiHzbFEs7Q45k7h6/CeaHuAHbjRnQNotmsWKgFaOgF4Thugm9BA15E4
	 ssViSqsIK/A49KyM3PkCBLRtdA39SeG4grMveEhu0+Vq0DxpA5lBl1M5QAK4X6AHqt
	 tSwxoyLHsmqdi/VuI1u6Feu8i9f3ScduyyuVzt2t9bHgzHfCl4PiLDqSyPVG0BiFK1
	 O7pTqpztSboqGVB09gRretT2FHBO6LAXojisdHqCAH3y/TN8T4lSJr4Mh1G9dOvpYX
	 nEFw4+p/i7tSKDH6opba6CZB7xqiGQbbnLpT69yCQ5KBlDgik3xfb6ZWFc9VhvNWi8
	 gHjPQimeD6xgw==
Message-ID: <c50aeb03-538b-4dca-9a81-ab84bc19a333@kernel.org>
Date: Mon, 27 Apr 2026 17:40:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 4/7] mm: add page consistency checker implementation
To: Sasha Levin <sashal@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, akpm@linux-foundation.org,
 corbet@lwn.net, ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 skhan@linuxfoundation.org, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Sasha Levin <sashal@nvidia.com>,
 Sanif Veeras <sveeras@nvidia.com>,
 "Claude:claude-opus-4-7" <noreply@anthropic.com>
References: <20260424140056.2094777-1-sashal@kernel.org>
 <20260424140056.2094777-5-sashal@kernel.org>
 <4b961a07-b72d-4c8a-ab49-23f61ed12b53@kernel.org> <aeuC6TJ4XowazVZj@laps>
 <aeuFnuiYDBjttEKt@plex> <12985b32-88b3-47ab-8292-2e0ec6f5fbae@kernel.org>
 <aev-DS4YTp5soVPd@laps> <3146ebcf-5649-44a7-aa21-163bf404c42b@kernel.org>
 <aezt96xgz_qyf4d-@laps> <f910969d-1071-4174-bd42-da45cb6f9749@kernel.org>
 <ae9ucgtCNf0JQtGu@laps>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ae9ucgtCNf0JQtGu@laps>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8D348180012
X-Stat-Signature: kghhek5fapab8h311rziunnnmcrzuz4h
X-Rspam-User: 
X-HE-Tag: 1777304444-304195
X-HE-Meta: U2FsdGVkX18M+jKI/GNjyUsAiz1QohYahdLuNwc/WVInyK+pKJAgxdwtuaavxr+A4N0U5RcS7HpeFdtHxBsyW9/CybTdi0vuiInvFyaxN6IuMcdB2iOIcaILZ3s9z0IBw8JpREtTt9S5vedzJ6cYi5KpefIBe6ofXpi+SxZRlYAmf8LFKMGHEuUrAETKNWyiFzGnWrQT8jhjPZoy7Ca5YAU0mNz+pEE6RtSUre2MJbeZo2jz08tJWZ1YK0llEXMy1KS17X5YsihDB4xSaku8Ipc0JKqPYL+cW7uC+HnmSvg/c3tRc6rk86pwhrXSHhcfvcB3yoe/9ZKJu03p3F0KxKJXm2JR+VW89XEH0iF60LZa30hxCAYbptOQdl9UrA4x7X3kGi+DS6c66bg941UrdY0PJo6bSf1gnybOAc80J6Qzoeht33m5Mt2FT43559+cMr67JF0aZVmMjY6JXlePMATQX4aYE70y6TZILTT35T1JqA+EmO6ZO8VTiHRUcqlwH5WbJmWR+daelktCx5KnPDl3I6BWuIn5uxs9sXx7YHWrubMP+oQjvBkabEAPV6sltTKB4P4AiHIqykbSj+q0sdAbuXO/jHyAIlypdLDmG0moQFiXSCMLHakfyXtAZcPN/uxlQ1dNcOlM40oHS1NkOyJaZVDXBBZa6feIdVAV5dPmvTuMtX9ovLRPJMjd9irDRqODG+oqqIuOEZfXxJMi87E/Y1GwcOZPUZTl1MGhySPs5302NAzFEVPVJZH2ZpHif1ZqM1Ht2MgkWzRwGElpGRPUVLclJODTz7yATmTPH5Cz0AZVMNcmLTN7HWM7H7NbToHHgnbBWSIf95jhhqap7ehVB7xgwcy541nD9R9h7kXab2C5aAlG8k6AFPB4f1/+aQcZ/70GvdG9uNKUbr8GXolRZj5vL7SyQrmYuA5EMo+25ZIHhc5rL/2R+UgwbkKC7S6iFQ7oFoxPPm50fBL
 ho4c2cXZ
 LNHhh2dEQHqumZCftXeDyoN5bJMknjJa5E9sLAST1EP8tpNCex61aakOFLM0B74fRMNgyAwiGHGSR2Yi+pUGwbSc12cskz5+76MOwMv2Z6ORlrZgU92r9I/nHhaqjvgM4wEdeu7R/hywCYp6v+YQcRBf6zfORSEHfShl1KBXVBRgMGuzXxcJRf5JhIUkMY4sv4T7z1koB+yHiYqfNJt6gzAZrv2fH/wC+fBx0CCHTqkZs2umMRJFL7+4M2sAKOOa4JSc12zLmQJYmQ9ZDYimFrZ8ng+y1K7zz+0US
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>>
>>> For something like a datacenter deployment I'd agree with you - the odds are
>>> too low to care. For an unsupervised self driving vehicle, where there's no
>>> human (locally or remotely) available to take over, I'd like the odds to be as
>>> low as possible :)
>>
>> I thought that people usually use special RT OSes (with proven logic etc) for
>> any safety-related systems. Using Linux on the core safety system sounds ...
>> scary.
> 
> RT OSes are indeed the current approach.
> 
> s/scary/exciting ;)

Not so exciting for the passengers ;)

> 
>> But, I'd expect corruption of other data (user pages? page tables?) a much
>> bigger problem than page al locator metdata? What am I missing that this here is
>> -- in context of the bigger problems there -- a thing we particularly care about?
> 
> You are very correct! The allocator work was fairly standalone, so it was an
> easy first project to tackle.

But in general, wouldn't we just expect ECC memory to give us an MCE, so we can
detect what was corrupted and act accordingly?

That's how it usually works: hw detects a memory corruption and injects an MCE.
We detect that we corrupted memmap state and kill the kernel.

Why does ECC not help here?

> 
> In general, the approach depends on what we're trying to defend from:
> 
> 1. bugs: an ASI-like MMU enforced "context" system.
> 2. physics: just like in most other areas - lots of redundancy. For example,
> consider redundant variables in safety critical code which exists as two
> copies: var_v1 = value and var_v2 = value XOR mask. When accessing them, read
> both copies, XOR the second back, compare.
> 
> There were a few sessions back in LPC about this. Here's the one from Bryan
> Huntsman which gives a good overview:
> https://www.youtube.com/watch?v=ie_ClBCed94

Thanks, but I fundamentally don't understand how RAS capabilities interact here?
We have mm/memory-failure.c for a reason :)

-- 
Cheers,

David

