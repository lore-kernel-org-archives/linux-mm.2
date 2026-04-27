Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87F9EFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 14:11:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B14D16B0088; Mon, 27 Apr 2026 10:11:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC5B36B008A; Mon, 27 Apr 2026 10:11:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DB556B008C; Mon, 27 Apr 2026 10:11:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C7226B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:11:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 219BCC0D6B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:11:03 +0000 (UTC)
X-FDA: 84704522406.08.232CBA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 55F4D100016
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:11:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WOknQOVg;
	spf=pass (imf14.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777299061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EGu/FqKKt59qxHbXsKv3a2TEa06ECdnhAIhkpnsE9eY=;
	b=8eQeWq3egPl4+dnPZ264d9YBrjDpVBEXmvW1jGGKvVpJn7HzsnRP4ZBw4uNwVK+idtjf4n
	6JAkzZxV2HENXAM+t+M8vWR4TzF6Gg+AYDrpUXnPMXQTFuuChL5O6K1zYeKx6Bw96Csy5V
	91tx5BvYMf+M2KQpU+mb4Tci/Tx7AJM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777299061; a=rsa-sha256;
	cv=none;
	b=GG+BEriNtjv2TLkwgFx+7PqJeHCa7iUckvD0ZU7N6DWMO7jik8t/ucNz0eFoekmfcSml/n
	KDUh/pM2O+WMKIG2TYbm9pXJtigTUDd+hOZuY2hDf4B8fQ17X9mUdQXra8kvEcw3nzxt8y
	Lcgin17w9DsRVxPv0wYoUK/uzN7X1+o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WOknQOVg;
	spf=pass (imf14.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 141B043A32;
	Mon, 27 Apr 2026 14:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E09C19425;
	Mon, 27 Apr 2026 14:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777299059;
	bh=h0NbYrCCZOEKkS2NsmUG0UAZWp9mvLLnt1P2UjZO87s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WOknQOVgPbUQDuhU1NhAYK9JNtY2qAEFUe2FWBcfjKM1C9jxY9m5ykZu0/9fQ/D+4
	 N1xQdbs/XTjqszZQ67NqIn+Zb+K57/4Zw711A+0XdFtvUzjV0uutggPuj9tAbf9zv8
	 vTfULqYfUOmwfCbg19UgBkUTkg3PndxcsnkNAz25HQQPm+XsyW2k/h/KDVKWbHElts
	 JBqJyWmLz9ZKZZhZSEUiHXVHNlE859w9Hh7og0b76cRfTGT+2EODFYrU9MCdUFDVuz
	 7jIbV+gpHMlCTpkWUXA6qQYVVVligLIumtKhYCFxcje/apK/+JaMMzP/dd/tVSuW+s
	 HljY3Y00D8u9A==
Date: Mon, 27 Apr 2026 10:10:58 -0400
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
Message-ID: <ae9ucgtCNf0JQtGu@laps>
References: <20260424140056.2094777-1-sashal@kernel.org>
 <20260424140056.2094777-5-sashal@kernel.org>
 <4b961a07-b72d-4c8a-ab49-23f61ed12b53@kernel.org>
 <aeuC6TJ4XowazVZj@laps>
 <aeuFnuiYDBjttEKt@plex>
 <12985b32-88b3-47ab-8292-2e0ec6f5fbae@kernel.org>
 <aev-DS4YTp5soVPd@laps>
 <3146ebcf-5649-44a7-aa21-163bf404c42b@kernel.org>
 <aezt96xgz_qyf4d-@laps>
 <f910969d-1071-4174-bd42-da45cb6f9749@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f910969d-1071-4174-bd42-da45cb6f9749@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 55F4D100016
X-Stat-Signature: h7wiecxteo6dzymc1q7mg7giqww3t43p
X-Rspam-User: 
X-HE-Tag: 1777299061-809579
X-HE-Meta: U2FsdGVkX1+WankYYSRYRYgh691j5WeEvoAlGiNwRz5/ZJyP0iwhbbNOKJF4sCF53ZufiJF9Voz4EVeHtkxMmEXrvgIqHXRkHsIRDFz3btJ9fsGNZscYaxdIE1jexc4rKkddpBVnTGEcU2w9JsWltzZwdz94tSKT16x1Wk2dAxMSib4RKr04nsZynsxD4plpzOlgg69w7u2lN3mst1ru7/AvqrQT3xiPya1VIeBP7hZc3133kPw1EIXrLu/WS0Yo6WiPs/tWxzHBM7DppuBPOXrZjR1Bu+FWGulSbILoy6jkuM9QGRCnVYB+wr9xNGLgsxqe5fw5wpCUEE0/3lUn30eMCMoZHBvZNT9uGJDbmfJ+G0fww/CjB/sscdFT3N4J35mRb6saMnNTX4DQMNF5kMNOzI7jyxMSSRaQ3jfVtmQQ4ZhuJwWl7HAWnDiwxAiCH0MtOJEmoqJ4oGFdur5bU96eAXRPPqOI5Pepid15ovifPupetTCuJAJ3i6O+jS8e85G+NBMiEzkV69trTM0SdZZWubHMPhuywdFjAveFdLU/X5FoVCRt40zwaSKsW8IOrqN+IdA4qFKh6QxyFRqy+85hsiOG2c8QQF8NG7L1O/AURo3mhfl330EXs2WFeRKo8n+6bLbgHDpuvNSYtiYcGuHpFGdA6s16jL6Ard4iJc8gB7thWg1U3m7BuOBxxZgazKAqn9VmSpuH6rrNtuxWwUEmtrs6w6ChNs2tVwLgflyJcz5kegn0DoziQsDUEmArFrk/99tb+6EydwAj4rGNNi2KoPUOJsa2/yPrYjnl5gSkEcXpTLOPt8R8rbqN7aygWWWp1CgwsrzUcrL2EjuknRsd+JoORB720SHOJFBeyuB3g/F2mWj0uVOEOINPEJ+k/ml2DaBi6SejPfnuSIvDJX7YKVUdiIHS6aoIHXd2/m/0OS7CYNMObEQpBk955Lz08ANGKS3M7k+myhu5+i+
 w4s3yD4r
 BZY36H3QVfYo8Kfs89w9SWbjr3pV9y/+hjCRqMe34I46YTbNDk0BQmpBMjew2kw8LGHPulacrWi84u39E8l3ekvMykPdXt/PQG3iWnu7c4PffOD5jIJcl1imqqAysaigR/p+kMkxQ1DU3U9vUWecAtiwjajqegsqr6q4ReTrcd0Ukd4w1ne4HOljbd/s/SPunCHNukdMPrIfFBH+qMLhhYnHMKb21ETke9TdLxMTEWx9cxnsNGp2uujNKCtpH9v586sMLcph3Svb4mednPzF6K9OnSdxwRGXhlHloCSKZD6227DM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 02:32:43PM +0200, David Hildenbrand (Arm) wrote:
>>> But the real question is: how far away do these bits have to be in memory to be
>>> considered "independent" and not prone to the same corruption?
>>>
>>> 1 bit?
>>> 1 byte?
>>> 64 byte?
>>> 4096 byte?
>>> ???
>>
>> The notes I have from the research side of things (which should be taken with a
>> grain of salt) are something along the lines of:
>>
>>  - ~79% are a single bit corruption
>>  - ~9% are row faults, so multiple bit corruption within ~8kb
>>  - ~4% are bank faults, so multiple bit corruption within ~512mb
>
>Interesting numbers, thanks! What are the other missing %?

  - ~6% single-column: bits in one physical column across multiple rows
  - ~1% multi-rank
  - ~0.6% multi-bank

>>
>> Obviously the numbers would be very different depending on usecase, hardware,
>> physical location (did you know bits are more likely to flip in higher
>> altitudes?)...
>
>Yeah, heavy cosmic ray apparently makes the problem worse.
>
>The 512mb case is obviously tricky to handle (and is very hw dependent).
>
>Placing bits at least two pages apart could be done more easily.
>
>>
>>> "Embedding both in page_ext means a single fault could
>>> corrupt both the tracking data and its redundant copy in the same
>>> allocation region."
>>>
>>> I might be wrong, but isn't that the case for any such fault, as you don't 100%
>>> know how the DIMM is organized internally?
>>>
>>> Do we really expect that a MCE event would, for example, very likely corrupt two
>>> neighboring bits, or two bits in the same byte etc? What are the odds that we
>>> care?
>>
>> For something like a datacenter deployment I'd agree with you - the odds are
>> too low to care. For an unsupervised self driving vehicle, where there's no
>> human (locally or remotely) available to take over, I'd like the odds to be as
>> low as possible :)
>
>I thought that people usually use special RT OSes (with proven logic etc) for
>any safety-related systems. Using Linux on the core safety system sounds ... scary.

RT OSes are indeed the current approach.

s/scary/exciting ;)

>But, I'd expect corruption of other data (user pages? page tables?) a much
>bigger problem than page al locator metdata? What am I missing that this here is
>-- in context of the bigger problems there -- a thing we particularly care about?

You are very correct! The allocator work was fairly standalone, so it was an
easy first project to tackle.

In general, the approach depends on what we're trying to defend from:

1. bugs: an ASI-like MMU enforced "context" system.
2. physics: just like in most other areas - lots of redundancy. For example,
consider redundant variables in safety critical code which exists as two
copies: var_v1 = value and var_v2 = value XOR mask. When accessing them, read
both copies, XOR the second back, compare.

There were a few sessions back in LPC about this. Here's the one from Bryan
Huntsman which gives a good overview:
https://www.youtube.com/watch?v=ie_ClBCed94

-- 
Thanks,
Sasha

