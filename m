Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0507AFF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 12:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43FF96B0099; Mon, 27 Apr 2026 08:32:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F0FA6B009B; Mon, 27 Apr 2026 08:32:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DF846B009D; Mon, 27 Apr 2026 08:32:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 197F96B0099
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:32:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B69E7120193
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:32:55 +0000 (UTC)
X-FDA: 84704275110.11.0DE56FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C8C1F1C0008
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:32:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ip7GywcA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777293174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CbaZe1q9vbV9Pj+NxZ5SyOZz4tsmVzc+rKJJeN1TZZI=;
	b=i8rBiqFa+S1GR6ha2MfENwcLSJdm2PRIWsG8oUX9dD+5EG6DIQ46elbNZ9cylENnc+aKzz
	mo398hOkyvqp0WyQ7dCXN2e/ntbySbR+QYvoMasZE1FJGREXpz3yyYrDTOliEf9gA/1Z52
	N/6tEHvIggLM5frQid5hYsBOLZ5OzUI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777293174; a=rsa-sha256;
	cv=none;
	b=GUyvJ6xHhOuFGntBQCfTp26b9L2Wfg1SnI9+iBJK1UyIFJcwrQA6nRC6x1QAVovXjbKBMK
	ZcwoQxgB1+BMzFGvpXoji65g8OPwynq2Uk6NP5hSi5aF2vbGjDS62PLSy1vrNhPcmyUR21
	1uRfojhrHz1qWTImQCeROLqYcuQo4/U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ip7GywcA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 746E243E9C;
	Mon, 27 Apr 2026 12:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3FBC19425;
	Mon, 27 Apr 2026 12:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777293172;
	bh=xvYQlzxQ1hq53wWdlNPDCV/eKlBZfhodpK+RYNlKyPY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ip7GywcA1FH/14ypAf5q1GhBaMpCJMHNJ0oNwZyx91OdfE7ATWTVoPYbEIH7xG399
	 KCazSQ5YkVf5Fw0qo9Y2P5/or6YxBg947RjhEPACI2CfczVh4hUxJESc4w0C9S1xoT
	 oi9aqHS/7BEzQsQLf5oNBRAGWMRMLABkI2mLa91GPBaTCXdfmwUaqUu2u5JvvPOTI/
	 Zw50WOSUPMqUC7sOO00eBGgcD0aKmrJSVtzAqNShit8EgXCYqLfWhun4YWoZ12gdZI
	 pITTuW5YaGT3GDvAl8NrF4gkCzYlwkt38O3AH7YXPj/zN+rdrAmTdtkTX6jCPTIJlB
	 GRpeFz94yPTsw==
Message-ID: <f910969d-1071-4174-bd42-da45cb6f9749@kernel.org>
Date: Mon, 27 Apr 2026 14:32:43 +0200
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
 <aezt96xgz_qyf4d-@laps>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aezt96xgz_qyf4d-@laps>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C8C1F1C0008
X-Stat-Signature: fk7d15j6m1beoftuenz14rcdazhcdm6h
X-Rspam-User: 
X-HE-Tag: 1777293173-847568
X-HE-Meta: U2FsdGVkX18pcs8UU3HQhtrwcVojW/dFnlZZ7cXzSMeS0HgNtQiZuiBwgL6SCsjnJER4gIHF1wvaY5ZgsoDLfZT68/2W/LJj3ZjsL/09RNSjpiyYrh09nkONc0lpW7Oxk0URU5hkayURi03noU8HA4m3XAHlobmSCrsvPEDe4PVA7ntzMFaM9TZcom7iMCg5oUDXJuGzAXX/FPyZPcm2IqxvajIZ98o+5Fkjpzo+ALuCqGzpcrdFymVpx13WYy3YzffTskjRsxrJl0H6cfc36bEnAAqOJHF5/Ff0WynkMQUD+3iIVT9OEJO3IG9YkOSe/CfPWQ9lW0vpA5Ki2iOe+v44WdEfU0bV3jl7pVm6GSyHLY1KtI0Mfds2+YTbfLtP47RdlSolf0aP4jf6yPmrA6V4ynNKUtOujAtENMfyuv3CvLzJjC3rCafLvkKEmiI965jK/9FguveuhKXowZ3LYGGa905jzaesxrPSwQ/r7FQFjPOddcsG+3GAtx/g7diKcp+XrfHck0Y3UdNh0N4HNa+yjTXrUwF3V486wiCcNpkzu/USMyuYoVbqPANGHzzn9dornnYaoeO1W6sTUE4UW4loE+I+bYpf4IHQsOtHtuptnwty64yBd2c2GTUe1GELw0j71ttNY4YffzTlv9etpGrCu24UvX3GoHfMy3OVPyijdeeLzcmWCqBmJ4tJfifqGEFpIYtySP4lJ7d2o3vVk3ebD5aCv9wczx7ctAAYMyB6AjUO+lsGQGGhozGbcZzUB/nPII1+ldfze4vThvQtsL4EZfdDwyk0byhseS1t3ZVE02tdOS++SWJ/5Wy0hckCL+AC7iw9RrJ9EhaOB/s7GXccdxB6LpZzTSQ28n98lvxs0rXUpR0HUtsmAXbQAgBDbs4ta0l0k6g1DOFnlHcYOAIvvfUnabDTL0+Q1XfClX5iY1MlqBALS5ASHs/9gJxGSNc2yKXE9FejOqEzWls
 4JGhXFkx
 APYkvZ/nN9sd+xqQkwh+fysaxvmvrV2buFzEY+JmxJiZKSkBZAOdbeH8arXiai42E0J7o40kyi02HU81V3q5RErC/hrb2jszYFPSjJChLurFpLl/UXamheet7FyQ7S6cpj9CswdF5RgtAzHAGFLdmzEFbT45LnB6UpHdnk1p5KVuqb6kTKVq8cw4AGVnMpRH/wL292FLVd5e/dhexql/6yR1KNUsX7beWYHFHs0TVlEVwVPB17xPS/PbiaKj8wVUGnPelh3V/UPCsZjFsCCBQ2/YCjJot/dBGKeML
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> But the real question is: how far away do these bits have to be in memory to be
>> considered "independent" and not prone to the same corruption?
>>
>> 1 bit?
>> 1 byte?
>> 64 byte?
>> 4096 byte?
>> ???
> 
> The notes I have from the research side of things (which should be taken with a
> grain of salt) are something along the lines of:
> 
>  - ~79% are a single bit corruption
>  - ~9% are row faults, so multiple bit corruption within ~8kb
>  - ~4% are bank faults, so multiple bit corruption within ~512mb

Interesting numbers, thanks! What are the other missing %?

> 
> Obviously the numbers would be very different depending on usecase, hardware,
> physical location (did you know bits are more likely to flip in higher
> altitudes?)...

Yeah, heavy cosmic ray apparently makes the problem worse.

The 512mb case is obviously tricky to handle (and is very hw dependent).

Placing bits at least two pages apart could be done more easily.

> 
>> "Embedding both in page_ext means a single fault could
>> corrupt both the tracking data and its redundant copy in the same
>> allocation region."
>>
>> I might be wrong, but isn't that the case for any such fault, as you don't 100%
>> know how the DIMM is organized internally?
>>
>> Do we really expect that a MCE event would, for example, very likely corrupt two
>> neighboring bits, or two bits in the same byte etc? What are the odds that we
>> care?
> 
> For something like a datacenter deployment I'd agree with you - the odds are
> too low to care. For an unsupervised self driving vehicle, where there's no
> human (locally or remotely) available to take over, I'd like the odds to be as
> low as possible :)

I thought that people usually use special RT OSes (with proven logic etc) for
any safety-related systems. Using Linux on the core safety system sounds ... scary.

But, I'd expect corruption of other data (user pages? page tables?) a much
bigger problem than page al locator metdata? What am I missing that this here is
-- in context of the bigger problems there -- a thing we particularly care about?

-- 
Cheers,

David

