Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C30EC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 06:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C140F6B00A0; Sat, 27 Jun 2026 02:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC4E96B00A1; Sat, 27 Jun 2026 02:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB3B46B00A2; Sat, 27 Jun 2026 02:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80A676B00A0
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 02:57:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C1D208FC9E
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 06:57:32 +0000 (UTC)
X-FDA: 84924786744.14.2F1A123
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id E3A4CC0003
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 06:57:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mIKjcWkp;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782543451;
	b=Cpd/4HV8gSP2XFaXsfgPLNRbSYb5zwvSg+At4zAvWCy1gtcIroK0OqjBU/t1LnpbRiMrl0
	0TbLuXF859bCV+oKtRycFnN6+ySQORTpvBmIfrlMzAFR9hV6+C2u027EgBj/2xYf2T8X77
	UUp73XrPXBcvbC+YomA6Z2Gxjssi4L8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782543451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/mXf9uzTDMtYNiYQq1kgu0qq3btevTgKJtXOPMqdv7s=;
	b=SdbygToEvgFNDjyNs3V5zj9AKZTAKwf9QnEkkr9JUylT21oOWzO3dik5hA6naQ4n2Lfm2X
	x/kqLH3MQm2ncDGyctTb0rpgTD5AQaCHFo1Ham7LZ93z6uKHMuo23WWCq8SMow+uU+5nV4
	4qjNjYt5/q24TOUdUe3h9FJGUBMAFuc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mIKjcWkp;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <fba044ed-43c7-428c-89e9-89f35b789dab@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782543448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/mXf9uzTDMtYNiYQq1kgu0qq3btevTgKJtXOPMqdv7s=;
	b=mIKjcWkpmuPo2qiO2D12sMuwXdhxvyAlAzEDqAl0qeA9PgmtgnOZ6k2wn5iHzMQPefoS35
	dHgpNPzCs6W8+WARZb/MIRrHt0uZ6i1bjxbAbuGGiLAHLaVPo4C6MEKTyx+UI3D3okabRG
	uRQ4ADOtOgHOvyg0Vw9jqilKXKNM058=
Date: Sat, 27 Jun 2026 14:57:00 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Harry Yoo <harry@kernel.org>,
 akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, muchun.song@linux.dev, peiyang_he@smail.nju.edu.cn,
 mhocko@kernel.org, roman.gushchin@linux.dev, ljs@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <aj12aVq3he6q7b2C@cmpxchg.org>
 <4c7b0c46-14f0-4a62-893e-e50714e09b74@linux.dev>
 <46ac28bf-5be1-4600-b522-0a1aa76c28e6@kernel.org>
 <08cf8972-6cfc-4452-9a3c-88e0368dbbf9@linux.dev>
 <afdaff7c-fe6b-40da-8f54-aeeab8fe8867@kernel.org>
 <90fd5300-1016-42e7-abad-08ad85fb62b4@linux.dev>
 <5a0c6597-6b96-4781-a71b-fd1298b2b7bb@kernel.org>
 <c0e366ec-ee5d-42d9-ba33-7c630660e8af@linux.dev>
 <aj5I7JAXWlTHRyEW@cmpxchg.org>
 <57c18afd-e2a3-4b37-90b6-f2a4c758e8aa@linux.dev> <aj6xzyqtwd4it0kZ@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aj6xzyqtwd4it0kZ@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: jm4ew16wfi575uy6cqdz5hfdc3ikrh7c
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E3A4CC0003
X-HE-Tag: 1782543450-110743
X-HE-Meta: U2FsdGVkX1/RdlBOcl2HxCPTkjbJ7DXKMEW7cxbh4n6Q5l8E/Taf8m7qHLC+bQUyKRJHcDLCaxgbFbOEDOXldQpFOyHKOts8rFUlWX1dd3hveHM96Qekk6QKD/60vr6f+98nYU/X5meCaL9tJmbuhb+MhEvX81MBBPM5a4TMKltQtrks7LAsntP0EI2KMuQKKERxI06URw8gQNQCPFPWXP8NQ0JqvN5GBWGYiAiPXQmGVfFhoGrk9QwwGoK1zsFmU8QWe/ufkodfXXhvtjdL46Ktl3TpcB3u1KCpcDLzeJv15FINuNV2UiAIhTv2aOYFsIsPhFU6mWq04eDPkcuUaO4o5vN4ljwr5k6DLe9Gm7NebpN6/cpZUTS1z6d84Ds14xdzJE+PM7Wyy8ROQBVm/JPGGA6+d8d9Q32b9KaMM6IusZJiWeB+C4MzCcX40XPcazz0FokfrGm6VY8FhjaTCtQyu7cl1zDEoeFnG6EK41STGtt9n5jIzO1ASceoqV3RETILmWRIzP4EMlkvBYIpO72f/wM+AhopXDeCLWYh4IQ5BgyHgjofABMR3yP6QYc7iy3pqoTZomNaohZR0ZuzPBEgz9/AyDMY4srTAAKtYfjkTMxFkdBiSZSVOUtcphF999ql6u8iWIFd7sUZ7GhQOZzGJZLX5pDK2k3NONrenTXuz0eyg5AfllDk6d5bsc1w3ZRcxr4UFYfzZ0/LKJwmneLuPRG2IXDrVHp9Bod3I431endWHmPyy3v13iJ2FOifi5myArlgVFRNRtwE7LOmBXr3Zay5GYBQ3K9Spb6atFAUrFfYixynI3IMzHd721hhASfd+zdPv9Z7SIrd0NCwc1E7DgGgUoU7WfdQoozs7Y5HdF/kZv0qz91nUlrCCkO+PzLioKOtjOUSAWNSr3nN7nW5xPu+HqntGK48tfQvoemAHphjhK5TsjQDU56y4VNhj5opy6U8c860AwdWPUT
 ZiOUFRsa
 jJGnTuCqI/quLny3DZO/6d0QKa8U5YkVJUtCg4QctmxX1u+o2K0vAvPrLbRVepbS2+o+UAXo8hmm1W2Ablk3tQJvPDnMHsm5gibyu3nPt8dnKhvJ3CC7kbNjdiELch87sHzgT5oJHAJOCw9bzDmZRFDbilqBIQ7TYH/erQSh75sPf+nN2TfQ8XSVVdePkssiCipNWasCr9s/DCjKLcGxPA3ghfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/27/26 1:08 AM, Shakeel Butt wrote:
> On Fri, Jun 26, 2026 at 07:21:28PM +0800, Qi Zheng wrote:
>>
>>
>> On 6/26/26 5:39 PM, Johannes Weiner wrote:
>>> On Fri, Jun 26, 2026 at 03:04:17PM +0800, Qi Zheng wrote:
>>>> On 6/26/26 2:48 PM, Harry Yoo wrote:
>>>>> On 6/26/26 3:24 PM, Qi Zheng wrote:
>>>>>> On 6/26/26 12:59 PM, Harry Yoo wrote:
>>>>>>> Observing a dying cgroup should be rare anyway, it's worth focusing
>>>>>>> more on readability?
>>>>>>
>>>>>> While it's rare to encounter consecutive dying memcgs, it can still
>>>>>> happen, right?
>>>>>
>>>>> But is worth saving a few instruction in a basic block that is
>>>>> unlikely() to be executed?
>>>>
>>>> I don't have a strong opinion here. Hi Johannes, I'll leave the decision
>>>> up to you. If necessary, I can send out the v4.
>>>
>>> Yes, I was thinking what Harry actually bothered to spell out ;)
>>>
>>> The race is rare, multiple levels even rarer, and even *then*
>>> mem_cgroup_lruvec() is a quick inline.
>>>
>>> This way you have one block to handle that one rare race
>>> condition. One place to put the comment. No labels, no goto.
>>>
>>> Simplicity wins :)
>>
>> Okay, I will update it as you suggested and send out the v4.
>>
>> Hi Shakeel, do we really need to move lock_batch_lruvec() to
>> memcontrol.h? It's currently only used by reset_batch_size().
> 
> This function is very specific to memcg therefore I asked it move to
> memcontrol.h and not to keep in vmscan.c but we can always do the cleanup later,
> so proceed however you want.

Got it. I'll keep lock_batch_lruvec() in vmscan.c for now. Once there is
a second caller, we can clean it up and move it to memcontrol.h.

Thanks,
Qi

> 


