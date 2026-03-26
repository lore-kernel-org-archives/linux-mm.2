Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7A7D10A88E0
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 15:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BC7D6B0088; Thu, 26 Mar 2026 11:43:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 094836B0089; Thu, 26 Mar 2026 11:43:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEBB66B008A; Thu, 26 Mar 2026 11:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFDAC6B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 11:43:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 91F3FE1384
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:43:44 +0000 (UTC)
X-FDA: 84588634368.06.C103120
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 96BC540013
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:43:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AflVWE7S;
	spf=pass (imf11.hostedemail.com: domain of krzk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774539822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eJ8uyLAGPsYlzOxecTxE0rgHoqWq0oDDfV/0YCH68Nk=;
	b=Igqub9Jzoe6VRiwlquOZy5kMcjgVmBi6nRvER02B6WccV+LtnYzlzwC+3sCB6EFyx3VP5v
	ci2faSk5rSPw9tHQX57bPah8LwSNKIaxzHbiVjkYLJvblok0EE4yF/fFM58AOUSkbvsGKD
	fkcIa78q+mjEpadG/PwyJsrFMRYL6Qs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AflVWE7S;
	spf=pass (imf11.hostedemail.com: domain of krzk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=krzk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774539822; a=rsa-sha256;
	cv=none;
	b=1komkneQSZt7c5TsHE7HxYL/5hNYdbstaee4zZxYJO7RsD0rGk0m8tfTxGigdVdHAsucRH
	Tmn1nvIQo3I874qX751twzHKJVnKMiV4AduP3jGdOhN7QjUqJp3EdvFrZwM/MttO3L1b6E
	emR7kNe7X7mpuZyrOrcYO/gxqOW+Wcg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9487A417B9;
	Thu, 26 Mar 2026 15:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA6CC116C6;
	Thu, 26 Mar 2026 15:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774539821;
	bh=MBxi1eZ9X5Z7HPjFf5pEA+SACwJJgd5iW3TQLdtDzS4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AflVWE7SfTCDyHibg02fD7eoSk5xdCZeClBFBihknqgQ5CbkT7B7L1fw0BdP0BeA4
	 2jF/GPgoA9S0w278304Vs1xJI+VgWU9ZHjkaVVkK9fwHnDXem4AReFWoVRNMN+JGkR
	 PhNBDrAOgVPeWhlvAGkf/vO/+gp1mtrEHbOBz4vkRcKn1Qzs8I75fC7+/fO5mUTSSJ
	 PEu6xeNB2VzDddVLSYeCle/ZLHZHUaPFXY0NrK7LuCGf0i9vCGzlRyGeExegwFEe40
	 fIKttBPPYE/GgnC17ndrrbqJsIpNLahWYpX/gitiLnruOOD8p1PcxXCHVIuZfzbJmU
	 lOU2oTCfUY5iA==
Message-ID: <b263a722-e9b8-4a43-a075-46e4a753871d@kernel.org>
Date: Thu, 26 Mar 2026 16:43:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon: introduce DAMON-based NUMA memory tiering
 module
To: Josh Law <objecting@objecting.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Josh Law <hlcj1234567@gmail.com>, SeongJae Park <sj@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <kees@kernel.org>,
 Greg KH <gregkh@linuxfoundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Christian Brauner <brauner@kernel.org>
References: <20260326072737.341964-1-objecting@objecting.org>
 <cbd0aafa-bd45-4f4d-a2dd-440473657dba@lucifer.local>
 <b2cdda38-1007-41a7-a992-de953a088a08@kernel.org>
 <ae7dc7de-966e-4e04-bb55-318d97c61909@lucifer.local>
 <a9f267d5-b0a3-4118-a1c2-5caa8a3b638d@kernel.org>
 <14366e29-4ee2-490e-8e4a-0c5cace1f313@lucifer.local>
 <04B79050-4353-4FD2-A596-1474BDB94B3F@objecting.org>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <04B79050-4353-4FD2-A596-1474BDB94B3F@objecting.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 96BC540013
X-Stat-Signature: y4ewwa9qgx7u5j17roiihiahjpcf6tug
X-Rspamd-Server: rspam06
X-HE-Tag: 1774539822-708109
X-HE-Meta: U2FsdGVkX19AxZ21OhI4/LuPr0cf65Hb3EMW3yHBmXK/LBjWKuZ9IPGq7e5y9sMzq2OEUZ4klZGJODyW7DmC4YqVlW03j9nespjOsCs6vaMQ4aMatPpZLwBKA+FBTTPwaaYDr1sX0D6HnOY2QHSxavEOYitcaFKCppXF2GxBuyxrRkfXB2g801P4hPO4qMdeNLbMmex+ulyXgiKSyqkP1JfbO1fxhjHLYZGjOfTilrfgyttXBiby3haRNiVfGXA08QT+ZjIKh+X31E3EvnfuBRaIgedj3cmfwOY62WcBjh/Pa2ZdEl5ZUD8AP9aVgqqW/IIn0ctiSzZxpoLJpEVk+vnKsipL5X0y35UjADIV0J5dp5c81SCzFU+cBE7z61ERCysyyB4kCVgN47WyuCwrkz6h2jgBp8C/095m1gj0a6+DNUjzlEXOJJaDqEfWLWnt5SmUNEjkvK5+afhPxBkWY5OFm0f9tf69mgndDkitNAfw28JxnOBfxbDVhwAeayaIH9mVrZ944ZkMubHXbfCT/02pHSngXUmJgq0roqjJ0Afq+qkZGcBNmAoK/LiaxfowC14AgOLSAqHJKE2Ah+al4kC3OVWmfg8IBaRaVf9ampkAngQz43iFTkCwJ/q9igI7lH8y3YpDEzAwJIdmk94l9+/PfDnJHTQOJ0h4K6eHVgNNJFHQtWLMYXqcBZ7QSSnOEnQLhIT/OmaQHhl7LSsEpkQfKaWM72kutBpG9us60on0w2vHETxtQfNwXJ373DZpCF+yHiEVNOdjFYX6KPTL9n5w3AHyUtUDq3Amfx9s4eSWqWHBxmKKTbF1wXLNJbT0ev3Q/to82mb2VbDY4Tg5812DpYfpSL1VhVoxZEYU3BLRFzBWxVZxufmEH6L8QONUh3s7LI6P+Fpl/CJCdMKxs1zWbZ//KP8YDndyjR8wbmnMw0SzURNuxc3aBUS3kTw3Jw57OXNPFnpoPpAxfKl
 NGD4tkb0
 1lWuk0r85s1tR6Jl3KHUPiuQWP9jd3/004ZNcPizjqJMUgWg8XtD4ev0cPEwihzhye4ITIeyAZyVaiitEKzDk6W6E4QzD+sczTNXcK4NSF+3p1tuo2enk0aXSbKnae1AgZp40V655FBc7e8SsNxSFZEaJv76hT03lG4H48XlEOTS85/ZmqU+92UePRkJrWt7rxv4sFEILi9We+zBqia31l0sCGH5WwTAFeGn9hSEq/UGnW2m6bx39FN1B8Dzp2RSlzaEPee+jHML1KVIa6oSFQIYk/e3SER7oIBbwCyGQr8BJTWPqW2M+qGnXMYwWdHQCyjWpKsG9OecqsnWEhieiION9CsLGWvRISreBMMRevOEoF6M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/03/2026 16:14, Josh Law wrote:
> 
> 
> On 26 March 2026 12:50:40 GMT, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>> On Thu, Mar 26, 2026 at 01:40:19PM +0100, Krzysztof Kozlowski wrote:
>>> On 26/03/2026 13:29, Lorenzo Stoakes (Oracle) wrote:
>>>>>
>>>>> Answering to reviewers with whatever confirmation they look for is also
>>>>> a warning sign of non-trustworthy behavior. Or rather behavior trying to
>>>>> get trust.
>>>>>
>>>>> [1]
>>>>> https://lore.kernel.org/all/D47F8215-FD08-45ED-AB01-0A5C48CD41DD@objecting.org/
>>>>>
>>>>> [2]
>>>>> https://lore.kernel.org/all/2F84DD09-2880-45E0-AA98-204F10848F85@objecting.org/
>>>>>
>>>>> Best regards,
>>>>> Krzysztof
>>>>
>>>> Yeah this is really adding up to somebody abusing the kernel process. I think
>>>> 'Josh Law' or any other pseudonym that can be traced back to whoever's behind
>>>> this should be banned from the mailing list altogether.
>>>>
>>>> Also, as per Christian ([3]), it seems this guy was using the pseudonym
>>>> "techyguyperplexable".
>>>
>>> Yes, repos on that Github carry commits like:
>>>
>>> commit c04af501bacbef54cf97cdfb904ddf295f8327c1
>>> Author:     techyguyperplexable <objecting@objecting.org>
>>> AuthorDate: Sun Jan 11 04:21:53 2026 +0530
>>> Commit:     techyguyperplexable <objecting@objecting.org>
>>> CommitDate: Sun Jan 11 04:21:53 2026 +0530
>>>
>>>     ANDROID: sched/rt: reduce lock hold time in update_curr_rt
>>>
>>>     Move resched_curr and do_start_rt_bandwidth outside the spinlock
>>>     critical section to reduce lock contention
>>>
>>>     Change-Id: I8dfb4e33460ae4eeb0bb854cc2cb084ab5edf7e4
>>>     Signed-off-by: techyguyperplexable <objecting@objecting.org>
>>>
>>
>> Thanks, it looks pretty clear cut then that 'Josh Law' is an openclaw bot.
>>
>> To think he was scheduled to be added as a reviewer for literally all of lib/
>> recently (5) until various of us pushed back on it :/
>>
>> [5]: https://lore.kernel.org/all/20260308202425.C9EE4C116C6@smtp.kernel.org/
>>
>> Is it really that easy to game the system?...
>>
>> I hate the asymmetry of this - we have to jump on these every time and they can
>> send WAY more mail than we can reasonably reply to.
>>
>> I think we need a clear 'yeeting' mechanism to block these people on everything
>> once discovered.
>>
>> Sadly the kernel has been historically very poor on getting rid of problem
>> people (The CoC is essentially a swear monitor at this stage).
>>
>> In the face of this new kind of threat we probably need to do a lot better.
>>
>>>>
>>>> There's a github with the same name ([4]), and that same user made a comment on an
>>>> openclaw issue relating to linking it to gemini ([5]).
>>>>
>>>> So it seems likely he/she is likely using openclaw to fully automate this 'Josh
>>>> Law' user and we're speaking to a bot here.
>>>>
>>>> (Screenshots have been taken for the (possibly inevitable) deleting that will
>>>> happen later.)
>>>>
>>>> [3]:https://lore.kernel.org/all/20260313-halskette-annahme-94e782eb4ae4@brauner/
>>>> [4]:https://github.com/techyguyperplexable
>>>> [5]:https://github.com/openclaw/openclaw/issues/44134#issuecomment-4106247302
>>>
>>>
>>>
>>> Best regards,
>>> Krzysztof
>>
>> Thanks, Lorenzo
> 
> 
> Hello! Wow i came back to a lot.
> 
> 
> I can promisw you now i am a human, hand on the bible, and i will improve! 
> 
> 
> So i will add assisted by to any commit descriptions written by AI, or anything even touching AI, i understand your apprehension and i apoligize very deeply.
>

If 20 times you were asked for something already on the list - to wrap
replies - and you still ignore it, then I don't trust you are meaning this.

Anyway, you did not address the actual problems here.

Best regards,
Krzysztof

