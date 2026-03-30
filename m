Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF4EEFF494B
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 06:27:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD5BB6B0095; Mon, 30 Mar 2026 02:27:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D865F6B0098; Mon, 30 Mar 2026 02:27:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74EA6B0099; Mon, 30 Mar 2026 02:27:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACCA56B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 02:27:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4FE6916055F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:27:35 +0000 (UTC)
X-FDA: 84601748070.19.1B0470D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id AA9B5A0008
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:27:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LoKeSaAm;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774852053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LYgib5CfdBXKAU/89zClja5Ab59Hd0fPWa8vYVRdprY=;
	b=FhdV1y0PeIG4wRXR+0mMYQfc8b+UC8UcNylgvBre5kS+NRVjqhc+ViBRxnVaPqKbjUERx6
	9Vl/x8b1/2NyQZVOTxxh9h0YHL6pHPqfjxHk22clgeyqTCT4TBlICsQnoMD0x21fWQcluD
	UOhWEUP3odRzAYkVMKcY3cAhzGtyH8Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LoKeSaAm;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774852053; a=rsa-sha256;
	cv=none;
	b=gpc3vf1c3HSb33bvo3VbwsbiDqNf7j1gY76HhhKHpCqI/PUER2tTm8pIYVNUC5uzjXiTUc
	ds/IbxKzbPUEbXCybsWDCOeHgyA2GIRfZ2t8/VuJIlxIqyXVxgPLruLpNXeWGbgK9hNTZq
	GctJse7jHGBz2xmz5n1nCUdGGDV3RIc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 178B260054;
	Mon, 30 Mar 2026 06:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7ABC4CEF7;
	Mon, 30 Mar 2026 06:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774852052;
	bh=F6tQtOiqeL+/nkboi2AX5jGllzsbO3jm6gQrDf3DOT8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LoKeSaAmCVA/XvE5JWggK0zyIdnGXlJc9LLrGTTjArgZLcSx2ePiTjBciLjEwWcVM
	 Ne85zdPxFykfERTY4g/qq615ou6ErEgGMQ8u3QEV/HAXSmvCz5LebVcCm3Lq/RB2da
	 wKHdolV0IYHwXTSOWo3a7BSLWdnTyHEPtMMVa4eB01XDrbxlXUDldD9FUFTHeH/i80
	 nSKEk4SfX4LfOsj5qv7Zg3hBskETErx4ySPHkTsqieQ6vn2KXwCAATozu3tIO/KfPB
	 FsGmTqEeGKCpxzTIvmqf96Dffxv/ae4VEc+lobkZRUlYlHxPDR/8XRIcqUI/6syjHH
	 hklJLwdk/Ss/g==
Message-ID: <11429699-81b4-4c1e-b247-480136fd1faf@kernel.org>
Date: Mon, 30 Mar 2026 08:27:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon: introduce DAMON-based NUMA memory tiering
 module
To: Josh Law <objecting@objecting.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>, Josh Law <hlcj1234567@gmail.com>,
 SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <kees@kernel.org>,
 Greg KH <gregkh@linuxfoundation.org>, Christian Brauner <brauner@kernel.org>
References: <20260326072737.341964-1-objecting@objecting.org>
 <cbd0aafa-bd45-4f4d-a2dd-440473657dba@lucifer.local>
 <b2cdda38-1007-41a7-a992-de953a088a08@kernel.org>
 <ae7dc7de-966e-4e04-bb55-318d97c61909@lucifer.local>
 <a9f267d5-b0a3-4118-a1c2-5caa8a3b638d@kernel.org>
 <14366e29-4ee2-490e-8e4a-0c5cace1f313@lucifer.local>
 <04B79050-4353-4FD2-A596-1474BDB94B3F@objecting.org>
 <b263a722-e9b8-4a43-a075-46e4a753871d@kernel.org>
 <043CED5F-7014-4776-824E-07E027B7BDC3@objecting.org>
 <cea99016-5407-4392-9b7d-2e6a994f550f@lucifer.local>
 <E1A667AB-DCE4-4034-A36B-DAA458780A81@objecting.org>
 <e5d45f3c-4f46-40d1-bb7a-0a2f930fd7ae@kernel.org>
 <82256A72-42FD-475E-935C-629964FA80E7@objecting.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <82256A72-42FD-475E-935C-629964FA80E7@objecting.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AA9B5A0008
X-Stat-Signature: i1yoaen6by5xwutgm4f13eodsin8g9kj
X-Rspam-User: 
X-HE-Tag: 1774852053-466309
X-HE-Meta: U2FsdGVkX19C/U3A4LN6wt3EUEZoCN3qJTo967qUt83BUd3HK/GCDqGSObJ5+htJszFMAlH0VKX7B/OBXpCJwvwqeSj57jTU/IDrUFpvBzDB/RjoyzqK66agNjNbA/4pDfgi1FVOML2F5k+JI91sJkaGNPn0QsLusY4bcC3eo57OibEkd4+0ZHSC3hHMsTwMF2kI2GCFmLez2O7YzHCNsDFSpEfN4rdoaQckooOwN/YA5OpPYpBRLB+9cAdBXiDHY4Pvzl/Q7jwpqlgIMwCXzOLynBWRBHW6YiZy1OywOhLPl7q+z2NP5ly/K3sDy360kETY8ytTDX/JG4dLS52Yrenddw8nl7CIEx0ANLD6KQ/gBD8B4rxJkcnx7A5PsMMU4mwMFVmiZtxhOP2ihAdYj9Z8Y0LUm8GjtHziA9dBtqPC6Dgg39nrHl2gJBJU1graGUH2YfumuWUdpCRVXO/2D8DJQsPuPlk96az7aQCp9kLb8/7qm9h/TC2ZbhyOm6+6LFD/7Ha8YlyTl9k8/ubnw8GE7burfVH6HcS0oTwVH7MthpEcKGVg43CH4x9MVvrzCKVIlWoRilQUMsaZ436viKO28/1VZjigfQhm4DGrA931MexVcURipPNQ1Lrii9PrZjPCthDzuBwcoW+DhNsT7nm/WzIMOfQ99yc1fQLCB0uV0wJBXTPUp4zPVmJqh/ZdDpAyrZzjxrlqe38ntgjqWubR000mtHtw0XS4JIqIuIuJAVPvyxcDHgaxLYc5LGmFfgt+fYzVadpQU2bG9PQM3OWXpQ0NfSDgYHWUh/iJf7H1J/8nJuOZLrMMUt2xM4++BG7Dmq+pIk1jUFpvLmjEUfexARaJ7JyYo7VAZiOCPjTQDTjiWIUMg2bHpySdjIILVwIm/+9A4TJ0Zmok1hvkiTJBrHkLfARiwBiZALLdkil1aJ7bBOJxUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 16:22, Josh Law wrote:
> 
> 
>>
>> Josh,
>>
>> in general we try to be a welcoming upstream community. Finding people
>> that are willing to work on the low-level bits and stick around is rare.
>>
>> At the same time, we need people that are willing to get familiar with
>> the code base and technology, so they can help out with review and
>> provide long-term value to the project. AI use is only partially useful
>> in that context. Certainly not for writing patches as a newbie. At best,
>> to double-check your understanding (e.g., AI review), help you learn
>> (e.g., explore the code base), or improve your writing if your English
>> is really, really bad.
>>
>> I prefer someone trying to use their own words to compose a change log
>> and actually learn something on the way over some AI slop that reads
>> nicer any day. Often, when you write a changelog you actually realize
>> which corner cases you might be missing, that the design might be overly
>> complicated, that, maybe, the reasoning or motivation is bad etc. It
>> takes time but you actually learn something and are forced to think
>> (crazy, right?).
>>
>> The same is particularly true when it comes to writing documentation, as
>> people raised earlier in other context.
>>
>> Having that said, your actions made a lot of people's alarms go off and
>> there is pretty much 0 trust now. As Lorenzo says, even now we are not
>> really sure if you are saying the truth right now, which is a big problem.
>>
>> If you are, in fact, a real person, and are passionate to work on the
>> kernel, it would be best if you would start things very slowly and don't
>> use any AI for crafting your patches (including patch descriptions).
>> Stick to one subsystem and ask people what good starting tasks/projects
>> could be.
>>
>> Ideally, you'd find someone people trust around here, that can verify
>> your identity (i.e., have a video chat etc) and start mentoring you on
>> how to start working in the kernel community and gain trust.
>>
>> Now, I am still not sure whether I am talking to a bot here (there are
>> too many things Lorenzo points out above that are very suspicious), but
>> I just wanted to say that there are ways to become a trusted
>> contributor, and that information might be useful for other people that
>> might be interested in working on the kernel.
>>
>> It's certainly not by flooding the list with AI slop.
>>
> 
> 
> Hello david, thanks for being polite about this whole thing!
> 
> 
> so, you are talking to a real human, i promise you that now

That's exactly, what I would say if I were a bot ;)

As a first step, fix the line wrapping. The following document was
helpful to me in the past:

	Documentation/process/email-clients.rst

> 
> 
> I am looking for people to personally mentor me, so i succseed in the kernel
> 
> And, I know this is unprofessinal (and im sorry!), but my github is my best friend, i have a year worth of commits for you to see publicly, also i work with android custom roms. (Any questions, feel free to ask!)
> 
> 
> 
> So yes, this is my oppotunity to be honest,
> 
> 
> (Yes. I do use AI!)
> 
> 
> The reason why, is im a "perfectionist", i want to start human patches, but im scared i will get ripped apart, (or i wont get like reviewership!! Because im too slow) so i use claude (smartest ai in the market), and i regret it. Like seriously!

There is this nice saying "we learn from our mistakes".

I still remember the first time Linus ripped apart one of my patches. I
learned something that day.

> 
> Additionally, i hate being slow, im scared that the community will ditch me if i do 1 human patch every 2-4 weeks, which is my expected time (because i need to understand the code!!!!!)
>


Well, doing 8 versions of one patch set a day is obviously the other
extreme ;) For example, there is this unwritten rule to wait ~1 week
(and before discussions slowed down) before sending another revision.
There are exceptions of course.

In general, we're lacking reviewers, not code contributors. So we really
need people that can get familiar with the code and gain expertise, to
help the project long term.

Drive-by AI generated patches that mostly just consume more of the
precious maintainer+reviewer time are rather counter-productive.

> 
> I would love to have a mentor to help me around, and when (if) somebody wants to, i promise you now, i will start making human patches, and i will benefit the community positively,
> 

I think you had some patches accepted my maintainers, you might want to
consider reaching out to them to see if they would be willing to help.

But be aware that most people are extremely busy.

-- 
Cheers,

David

