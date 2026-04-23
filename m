Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E77EEFAD3E3
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 06:18:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D8C06B0092; Thu, 23 Apr 2026 02:18:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B10B6B0093; Thu, 23 Apr 2026 02:18:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C68A6B0095; Thu, 23 Apr 2026 02:18:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 38F596B0092
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:18:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B15661203AC
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:18:16 +0000 (UTC)
X-FDA: 84688815792.05.34AE656
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id F0F2B2000D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:18:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=apBH4UKC;
	spf=pass (imf03.hostedemail.com: domain of krzk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776925095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41/KAzEMUMfqbOTe3MQyLi6u2Lg1J3UofEFq/DANMWQ=;
	b=4ndR/kRWLkFditKFbbDz45rAdSr4Lge/ZV9JMcehxDWkI2RHAJDOQZfKN2DmQEx40nAHfv
	QgAXIZr0ngw4rCsgoP1nytkTuxKu1G08AHjzpWL0aHoYnhdI1G25HbHEpiv1/jRv6gim9y
	Jho17CUiLigNrtamnPFaf752MV0sfn4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776925095; a=rsa-sha256;
	cv=none;
	b=nuzticmlvt0MU4mmNZruRPjWqWMalJ518MJ07t4LSXvmyGyWqcM5Do/6sBgiGYWyfQqRIP
	TY+5GlvLTLRA3ySqwctV8emqN5v1G12+JX9Z8rTS8LNNWAoXxbFaEeMzfUXXa9I6Zy8Qaz
	Y8RhWb19M4KFW6u5vDhKuw7EiwCKMF0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=apBH4UKC;
	spf=pass (imf03.hostedemail.com: domain of krzk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0EF7E600AE;
	Thu, 23 Apr 2026 06:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AD9C2BCAF;
	Thu, 23 Apr 2026 06:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776925093;
	bh=w8/xn1EjfGIk/BpHx3NHrG9pNzqhRdhcMxkcCvpbrmw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=apBH4UKCGQhZESuhXkeHF0LIdezWU+srsiksnUg6L5QBim7iUgkXm3vy32GnM5o0H
	 cz59Gv/e+PHjxKQQ0TDNrUJnoFyEgGSilbrWaTl013TcmL9OZm9O4JOdHzMbCZ5LTl
	 HLQuqMkNpdnj8OWIlRBgstMnBrpxYgB4PuIHq7yRNJTZWvsNj1MjokmKGo85E/ItFL
	 Yi2CWcESHRZFmBFfeu6EB1aWb7JhTPN++qXsF3Bl2iGQMrrou67Eec6MdrP9AFc30L
	 qOP0eS3aG22foGF6DricinMOF0vvDV+SHRy9AnBh6VBpKsMpVm2p19f6IAl5vUiG7V
	 GfdCsc7EL9E6g==
Message-ID: <20ebb539-c4c8-4798-986f-8c50c1ebef39@kernel.org>
Date: Thu, 23 Apr 2026 08:18:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] MM transition
To: Josh Law <joshlaw48@gmail.com>, Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, david@kernel.org, linux-mm@kvack.org,
 rostedt@goodmis.org
References: <20260421094216.8dfe14a8c62f2420fa5aace1@linux-foundation.org>
 <16B7B5A8-EEA7-4580-A565-3A0B4DBB08AB@gmail.com>
 <aekbhQN9afqMBs4_@casper.infradead.org>
 <7BAB465F-C09A-4C67-B9A9-3C63ADD91AB5@gmail.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <7BAB465F-C09A-4C67-B9A9-3C63ADD91AB5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F0F2B2000D
X-Rspamd-Server: rspam07
X-Stat-Signature: sze375t36fmjm8c4nfbdbmc9cmxug3kg
X-Rspam-User: 
X-HE-Tag: 1776925094-594758
X-HE-Meta: U2FsdGVkX1+UTApKaMF2PNesmBk3SIO2HB5whZtkZXfbilB+N0K+USMjCx3RyHefMDPehTKg/oUIidyMcu2nDUaj3QyeAqbiSEwYVxvh6GtOCJNRN8RY+/mB0v2DZqsXHvoV5bDvl0NApJhyfbGjvh0op3ALJpaTxGTJ3veMQGQ/ThfwMQKBxItwIq5kuIkULDYZXgYiH8iUNDTR+lkOz4uWVkcK1Dgh3AJb4rn1ZiZX1ajiblQBQrRz02Y2cA3d7aU5aTCXxrqt7w1HIobwPsV8C+8OFCoNGul9qI3COb9Eop2Y3CiBrt6cSJfSMs47bJuCMkk5R32XS3Y5Z9fDEnZDm//CEj8zWABXkmo4aNwlbbWUS0kpU1aAF9ZF7J7o9pMYz3qEfTmt5xUkp9GjyTw/VverkLqJ8kUMWScQCINl9mFou4jyjyLQYladw11gBwjs1bbiaddeoGp9lGRrmiGft3xBqYQFBvfITFh58uTuoL0azM1o+pmFeUfUP3+hBsQckWoLZQy5tmnAskQGqnAu4FDUQK3S43msJ2rXB3TvgM8vJckFCTziHIXU46fGK7OKAtDcY+fTeuDXSqZEeQgi+vOVyuNfSEfmcfOakPUNVKV1aGC6NU4REDMGtmojUl8pJ7++A/TTH/czsIyT0u/GI8AJzRcNQ6dMss0bR+CUX5Ufj/0M2wEwF+dX/DBpa6qIyUZmC+4n73oWfcLTjwb8HZkklvbyHAhemBwimzY0qu6oYZETV4x5rquhJX0Z1vX8M6T89ih/2OQLoqoo8V3/OzP/P1Wbsec3igXh1Io1gIzNodn+zJIkOnR7okr3nFDai0MAYfwNZX6fkAfZvcYqPKmMoJBEtSqu2xhmoSIeiYUAdsEgqRPgi0jRE/4izbfudPBeEVsYNE3M7spJHd9eQquzn3Dxt4tOGHT4Hxlh3xyMzGu4qRTfq8y1lC6fscTwDoIaUC1HeVFCrst
 d5dV3WXq
 gSZvgdg2/XUPfSw07vPejmq6cvc1pFSYpCiNC9HGUve8RPXcw7JZBitw/7cebvelYuyxOiUSBxLKHbZSbebhfGmYn8SCUjA7uYPnuaWd9zNm3eNtdliKixCyLEamFEeu63lV1D6+tSY4UMwcFe09xbaE1S5ShVgI3I2uDdcsZ2js2XZxc6YEc04m8EQ2jiN2shWOc7kJGh374vl9u3/WXItVXxGOfpTjt9O9tK6jWnl2A2BYHsur5EGv2qD0uOZjKh0gMBhIh2fSWU2YShExDzXwxEXFqXG2Uw8nNYhwJWt6zmyYW+cb332tjf3Cj7aj+EauGzkPeWdkyYUXcrIEoOkibew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/04/2026 21:13, Josh Law wrote:
> On 22 April 2026 20:03:33 BST, Matthew Wilcox <willy@infradead.org> wrote:
>> On Tue, Apr 21, 2026 at 08:25:24PM +0100, Josh Law wrote:
>>> Hello, since I'm not coming to LSF/BPF because of my age (aw)
>>
>> What is this nonsense?  You aren't coming to LSFMM because you haven't
>> requested an invitation.  If you had requested an invitation, you would
>> have been rejected (because we have limited seats and there are people
>> who are far more qualified than you who did not get an invitation).
> 
> Sorry. Yeah, didn't realise till I googled it.
> 
> 
>> You already have a reputation as a liar [1].  Don't compound it.  At this
>> point I've tentatively assigned to you some other nasty character traits.
>>
>> [1]
>> https://lore.kernel.org/linux-mm/cea99016-5407-4392-9b7d-2e6a994f550f@lucifer.local/
> 
> The "bot" thing has been disproven [1]

The liar part was not. Till the very end you were lying about usage of LLM.

> 
> About the whole trust thing. I'm working hard to get that back, sorry
> but no need to be harsh.

Then stop such presumptuous emails about lib.

> 
> I'm working with Steven here to try and handle the social side, bare
> with me here since I'm not perfect
> 
> [1]:
> https://lore.kernel.org/all/20260402093410.040423b1@gandalf.local.home/
> 
>>> (And I'm more than aware this post is more mm focused, but I'm
>>> representing lib :))
>>
>> No.  You're not.  You sent a presumptive patch adding yourself as lib
>> reviewer, and that was also rejected.  You don't have what we're looking
>> for in a maintainer, and you're starting from rather further behind than
>> somebody with no record.
> 
> No, not in the maintainer way. As in like me being patriotic for the
> directory 

NAK


Best regards,
Krzysztof

