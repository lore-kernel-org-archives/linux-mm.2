Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 659C6FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A4956B009B; Mon, 27 Apr 2026 14:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82E4B6B009F; Mon, 27 Apr 2026 14:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6B86B00A2; Mon, 27 Apr 2026 14:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 588C26B009B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:56:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 080BB1B7EE9
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:56:33 +0000 (UTC)
X-FDA: 84705241866.03.BAF3656
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4AFBD140012
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:56:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G9238WJ7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777316191; a=rsa-sha256;
	cv=none;
	b=YeEepRYRJVpTKih82sl/5zwO9jXYwoxBva9xw7oGZ0LnGEjhsCY41Vl+UJt6Du608+FrUw
	NaIaGC9/5hn2T05FXzSdYumvghHXui5JerJ2JLNTxR1D1SKbJ2fFxJcnQaOC2Lll28RMT2
	YY95+iwY4wMICQz5W0ScAbPkYyWwXzE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G9238WJ7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777316191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I74jyHi6WfTZuDsMEJoTzRYGQk10/KNqNMOM844SYOU=;
	b=aAfvlXVmu+0JvZrdPlHCr3i5eJSylBbg/RT+b/43to7NYoSqEOVi1EpsbZ3h1FYQ91Fve+
	z2pQPliCwHR5LYeIZTx3ONn32beWw9TYf5QLqN8fxvg7L2poYVJBaBW/mz6w29+y+7c1du
	Zve722rrfIkK5hjyXmS5fJFwStChO7w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 547A5403D5;
	Mon, 27 Apr 2026 18:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0876C19425;
	Mon, 27 Apr 2026 18:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777316190;
	bh=MpePPJ1H5FdPyHmRmIns0IGr3K1GdEibm8qRgpRvHlM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G9238WJ7iV4t1t3oKjhnDqXFZakWlqZ4NNess3dlMDMIZDHFzAz+6JpkMSch/DGdq
	 yqRIdGKSMaWAyjx2gBngUZs5V4pr2d5q93yVOB3ZvorK6njgG5HQgFeuDEtn0oRHXF
	 Ckwmx05EscNn7uKnmfgSB+miF+SNL+JE9vaSYRwImrmW+Ot2mJKBqA7a6Nyv/IjMcw
	 bUtDgf8BO0YijpQhD1orjHfpR3dfUMxKBSl2P06VHVraZvhkcBFNBcaS1Y+7bBLpE3
	 MaTPGUsbci4BfS2Q1OcojHi9GuML14TlOK15iKFoR3hB5d2dIuYbrWifEuU9CaLMO8
	 YpkWky560Hz5Q==
Date: Mon, 27 Apr 2026 14:56:28 -0400
From: Sasha Levin <sashal@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, akpm@linux-foundation.org,
	corbet@lwn.net, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, skhan@linuxfoundation.org, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@nvidia.com>, Sanif Veeras <sveeras@nvidia.com>,
	"Claude:claude-opus-4-7" <noreply@anthropic.com>
Subject: Re: [RFC 4/7] mm: add page consistency checker implementation
Message-ID: <ae-xXHUGfDiFcBUk@laps>
References: <4b961a07-b72d-4c8a-ab49-23f61ed12b53@kernel.org>
 <aeuC6TJ4XowazVZj@laps>
 <aeuFnuiYDBjttEKt@plex>
 <12985b32-88b3-47ab-8292-2e0ec6f5fbae@kernel.org>
 <aev-DS4YTp5soVPd@laps>
 <3146ebcf-5649-44a7-aa21-163bf404c42b@kernel.org>
 <aezt96xgz_qyf4d-@laps>
 <f910969d-1071-4174-bd42-da45cb6f9749@kernel.org>
 <ae9ucgtCNf0JQtGu@laps>
 <c50aeb03-538b-4dca-9a81-ab84bc19a333@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c50aeb03-538b-4dca-9a81-ab84bc19a333@kernel.org>
X-Stat-Signature: a7f8jeg1k8e44j5if8eu84ichjut36dd
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AFBD140012
X-Rspamd-Server: rspam07
X-HE-Tag: 1777316191-793857
X-HE-Meta: U2FsdGVkX1+QJ76Sd/ANYFsDCt1cyxDibWPrnzTr5r7Z0Z/QpZ7Ch2HZnvIWDHGU5XkwSRkXiCgDPJaQqPJkhr0VI7mKqMRu7mxmMuDSM1WHqMH3p3WK2GW9+lUOwQdmYvJ9G4kEoYRXKPQZ8vdlkmqJaIdE2J6zG/GiZ/exuA4bEPg7HubgESiJ1b4wh7/h6cDsAb8tH5GIl8GpvfLrFx5zGX+QXF/CdxytMqYZa+Ywyj8aap97qBuQBq9VA42+zhEH1jx52a3DINyf1m2kY5l03k+EvK2B14Cmt95Lwgs6xvgFj+49jYtVyJA3vktp//q3+RmyUQe5fiYlMTvGjt7s67Kw/JWhWi4tn4KM1x5TOoSZFePQ0mPqmfaSd3OlXFeDvjJaiabDgbPneKVzN4HSsWHKkUAlAQIbirJoJd3/SP71GydgeQ720QDuAulE1rlWfrDej/PBA5gMFDF4xUtx8KpQJd5wDavM7H6hUlt4f2bYbjkkxkEaABoykgRDhTX4KloDvXmRZN4RnBZ5FGbL+u6lAgpOaD7uM9TMW1udRKARiDRr4pJtyH9AUMc55IbKpI7GE5yxMmRQFKX+XZKtLKFR+FV4dlpSyAFhmMMMkR+RY7LfNHlAdCq5RndDOfg3Np4JmmeLKItXMcW/0I+9bEMNGYK2KXxUaS4nTv8a06V7IT+yFg2Ws0ytYypkYtsaTE5xgKw6F/0teos08dV75pSNX6dYtShOooWexHL757irsU+a7oSNAStYYIAWXmOZDPckUeDcugouLs6y0z81xb5ZgWpafYME5GZf2qEy30l30crUTZBpEF+F+epSPB2+VyS58A1gdL0v9HygPVAFGlPiQ4geq4Kie/XDeSIj4Snsu1L6aZ8cCl9PT341XLgFcJ2fANhTotOii7pJQrPXV2EhFB3EQy2VLKiQz06KrxKrvPBpIwTkD7tsyWqhV6m9ch7oK1zDZKaATx8
 tbt+5yXV
 WnisBoTKHPfavs0pvc+7DjJ7KgBUCT8g6v+MyovRuqsMUGU1RgZmPYySQ5YgRUXm6VWFSYYJ/oqKEFY7AE/rQ7/10gS+Z1RwmjrCCOfWMYh0Y+/pCuLN3u5DfQ63nveaIqibirGLP2BldUMBCCubUWhyETFKHd3tee1/1G2i9blhbzfVocu54QmEPyOp+9w6ZhP8g5cJkydbCQI/bhA1P1F8o9DYNAHR0XnaSoAirvK3r9/colVFiSwh3T0DLsa7IpZCYdjxsC3pRtXPnqrKV8BcMXF2u/WbbV+tnbUmhiGezGT0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 05:40:34PM +0200, David Hildenbrand (Arm) wrote:
>>>>
>>>> For something like a datacenter deployment I'd agree with you - the odds are
>>>> too low to care. For an unsupervised self driving vehicle, where there's no
>>>> human (locally or remotely) available to take over, I'd like the odds to be as
>>>> low as possible :)
>>>
>>> I thought that people usually use special RT OSes (with proven logic etc) for
>>> any safety-related systems. Using Linux on the core safety system sounds ...
>>> scary.
>>
>> RT OSes are indeed the current approach.
>>
>> s/scary/exciting ;)
>
>Not so exciting for the passengers ;)
>
>>
>>> But, I'd expect corruption of other data (user pages? page tables?) a much
>>> bigger problem than page al locator metdata? What am I missing that this here is
>>> -- in context of the bigger problems there -- a thing we particularly care about?
>>
>> You are very correct! The allocator work was fairly standalone, so it was an
>> easy first project to tackle.
>
>But in general, wouldn't we just expect ECC memory to give us an MCE, so we can
>detect what was corrupted and act accordingly?
>
>That's how it usually works: hw detects a memory corruption and injects an MCE.
>We detect that we corrupted memmap state and kill the kernel.
>
>Why does ECC not help here?

It helps, but it's not enough. ECC doesn't detect all errors (For example,
SECDED corrects single-bit, detects double-bit, but triple-bit errors can land
on a different valid codeword).

>> In general, the approach depends on what we're trying to defend from:
>>
>> 1. bugs: an ASI-like MMU enforced "context" system.
>> 2. physics: just like in most other areas - lots of redundancy. For example,
>> consider redundant variables in safety critical code which exists as two
>> copies: var_v1 = value and var_v2 = value XOR mask. When accessing them, read
>> both copies, XOR the second back, compare.
>>
>> There were a few sessions back in LPC about this. Here's the one from Bryan
>> Huntsman which gives a good overview:
>> https://www.youtube.com/watch?v=ie_ClBCed94
>
>Thanks, but I fundamentally don't understand how RAS capabilities interact here?
>We have mm/memory-failure.c for a reason :)

We do, but self driving safety requires way more than the current hardware can
provide.

I'll point you to https://dl.acm.org/doi/10.1145/2775054.2694348 , which
researched these issues in a datacenter environment (so no sun exposure,
temperature controlled, designed to avoid electromagnetic interference).

"We call a fault that generates an error larger than 2 bits in an ECC word an
undetectable-by-SECDED fault. A fault is undetectable-by-SECDED if it affects
more than two bits in any ECC word, and the data written to that location does
not match the value produced by the fault."

[...]

"A Cielo node has 288 DRAM devices, so this translates to 6048, 518, and 57.6
FIT per node for vendors A, B, and C, respectively. This translates to one
undetected error every 0.8 days, every 9.5 days, and every 85 days on a machine
the size of Cielo."

[...]

"Our main conclusion from this data is that SEC-DED ECC is poorly suited to
modern DRAM subsystems. The rate of undetected errors is too high to justify
its use in very large scale systems comprised of thousands of nodes where
fidelity of results is critical."

The passengers you've mentioned before would be excited if they knew how high
the bar is around their safety :)

-- 
Thanks,
Sasha

