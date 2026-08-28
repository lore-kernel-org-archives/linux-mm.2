Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED103C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 01:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76AD06B0098; Thu, 27 Aug 2026 21:49:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71B856B0099; Thu, 27 Aug 2026 21:49:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 634596B009B; Thu, 27 Aug 2026 21:49:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A55E6B0098
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 21:49:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C2C821A0251
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:49:58 +0000 (UTC)
X-FDA: 85148997276.05.8F8987F
Received: from mta1.migadu.com (out-212.mta1.migadu.com [95.215.58.212])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5847B180004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:49:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RveU329B;
	spf=pass (imf06.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.212 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787881795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pK4NWYAJ7jcavge6OMwX5VMYub7+Zst5P9HToIkhdsM=;
	b=FW8IxdfDAIiwAW4jpF7vKGwyZ5SDKf1flNsND/VvjFB+iYNBSmLvnmoJSGlHXl4akiMJNg
	EaLP/maTsH7mmjn4eVh0X/ZLRUW35dcYUngXqm/SPGFxtAuBOYiDWq1mtO1G1dhHFgCTaI
	qbClCDEEsVUMG3YFcUXoh87Csbdtnks=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RveU329B;
	spf=pass (imf06.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.212 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787881795;
	b=GpnQY0iOutFJzXWF+sUD+43+lgdxlQwcFYwjaykinT2cuaB+rGXQOj8clNsGSfIUw3roU9
	2YeODX4Y6S9Xkox1L76pdhts1VwfKbd0eeh7EPDGTlt+Z79d8uloEB2KItrK8AkTUHuS3S
	5lCnqhxh0urzdZa1/Gnl4hAGiT0M56E=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eucM747RovHig5EMyBbZYOtolEwlJNF8D2Ih04WGVdY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787881790; v=1; x=1788486590;
 b=RveU329BNtI7q8Azu7CbUhJFBHkkoDGcWUyEOWxqC2Z5i366lTGGYCDWVr7p0LS5nRwhrqsX
 8d0znjvTneaU/Ty1aoguiw+8M9eLCAWiNLpRF/c5/zSs07A/lM9aDnbK+WHpYrI1scygPpLx7SG
 QsjA/K9oy90JxxcALMNfvBBY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a00269d0398ad22b;
	Fri, 28 Aug 2026 01:49:40 +0000
X-Mizu-Trace-ID: a00269d0398ad22b
X-Migadu-Flow: FLOW_OUT
Message-ID: <45518155-3a29-48c4-89bf-40d81c2ef6d6@linux.dev>
Date: Fri, 28 Aug 2026 09:49:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/mglru: fix ineffective memory protection for
 non-kswapd reclaim
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: sashiko-reviews@lists.linux.dev, tj@kernel.org, hannes@cmpxchg.org,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>
References: <20260826133054.88529-1-ridong.chen@linux.dev>
 <20260826134733.051941F000E9@smtp.kernel.org>
 <0c606cf9-2b5a-4549-8ab1-0be619487412@linux.dev>
 <apABJglqDFcB02VO@localhost.localdomain>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <apABJglqDFcB02VO@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w6xmuf1utwecw56wa4kwfc1f6q9ezf4e
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5847B180004
X-Rspam-User: 
X-HE-Tag: 1787881795-290966
X-HE-Meta: U2FsdGVkX18lpGMZApZqRsh/VkhpgcEeM6Vg53mFtatqbRSefrQ1mizW5snxbwjcfZphlJzY9uhKT3JuogSclmFt4W4npJdaScyuDBqFAOhiNig7n9r/Q+XMEqj9Mcg8FoNkKaAGIsMaCgxE+tYpFQEbnIVk7dA2kqM28XO0hLdwccqaK6KF7kkJLjLLs6lR3jfiJCTEuW3fL1f9OZCICacSLFM/xNrR/+c2uPhRxyFu9kTBEpGPb+pTDl5yNr5zZsQP+U6wpjQmSprSlR3DBhsdrTvQsfSyjU+gd5g6kZHOybjdITRs6loa7zM20iHXmoBJP5sXJSutRhFR89uRfY+4AOwbvnqYPRNGtEAlgjcjzqqB1iUXPMPP+2K7tccokLOMVmzzkZjc1PdVdMtcbhH0DGIIrrY1AEXiB/R3/ikC7WmjnY5OW0gquC1QI46lsmuyqhndTzclX877t6Ujjc+eGQvwlzMPybvVpOKOj2iL3lzrqA5/8HguF8MdhvKnoqHnonrSUQ8REd4LqYsYBm7VzHcItgdCd9ZV5PtmXQgwCa+y/8X0LgsWTW+xOeFyeowf4uStmlxNiYJGvuhkkIFt5E3jSQvyUA8a2X3tw2YTYA8uRTl/vCnXB9LRDfnDl/RXnJ8hT+nJz3boxE9Xma/mWEQEyGQa+u/zt+LO6aV+u96tx3EflnLXbjqCLmfPRoWVNLo7LoBvBzmzlpCJGTTR+Xeb6FAZENoHzlry6PfGom1xuKhCuJ+H2JtqU/APD/2rKjGt7Y5aXg+AyBlSUBsQ20qclAPmtM9UCyGnKVeYcq9L2gG2ZvDkWReBMlYB7WPmPUhAqoX3RSi8Sz/g6l3jzfY138yOvi9r1OYVDZB82JETzdkKB7v451+NfW/K3GgghWk/yMYSam8+OSDsCH7OoIIOLg6KlzXpbvs5GgNvIRG9eJbvpk6hY7jeVvtBH2oaTaHIluWRP+2BSKF
 +OPNSPHT
 PE4SjkOS2wo7jOqCMexdwOle2jZPPrNleVFKojXw+zdAQLra7sGkXhbXSq6F390m7idKlZDhNBVHlb7nwkc8ekSaIkXBcigArsFKouuc/robM5FFAJjlWSZvboiP7erLnUYRR+t1hhHjIGTRsnbzTGeFoJyRyZYWvqhYvnaM4xXhkdhwI+ufah18yitgzgoPGaJsqG8DCV8MzgoToIrZ8K8q5vKVTnsnuAmZj0XbSXdWArr3Hxg1wmKQjw9dTk5/rKipy2fzUVhzAqeQA29ktps7vLK8k+0FM8hrAOVQ6iN3PGNO5uzccDFQwWSBYB6eF09cTE/CjL5IBMDTwLoViEiN0ZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/27/2026 5:26 PM, Michal Koutný wrote:
> Hi Ridong.
> 
> On Thu, Aug 27, 2026 at 09:29:13AM +0800, Ridong Chen <ridong.chen@linux.dev> wrote:
>> On 8/26/2026 9:47 PM, sashiko-bot@kernel.org wrote:
>>> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
>>>
>>> Pre-existing issues:
>>> - [High] Integer overflow in `effective_protection()` calculations on systems with >= 16TB RAM.
>>> --
>>>
>>
>> Thanks for the careful analysis. You're right that this is pre-existing in
>> effective_protection() and not introduced by this patch.
>>
>> I'm not sure it's worth fixing in practice, though — the overflow requires
>> systems with >= 16TB of RAM, which I've never encountered
>> myself. So I'd rather not fold a fix for it into this patch.
>>
>> I'd like to hear the maintainers' thoughts on whether this is worth
>> addressing separately.
> 
> Machines with >=16 TiB aren't completely out of reach [1]. Then
> configuring such protections to attain the overflow is another
> condition, so I'd consider this a nice to have but not a
> pressing fixup (separately, with thorough review of occurences where
> total page counts/bytes might get multiplied).
> 
> HTH,
> Michal
> 
> [1] E.g. https://aws.amazon.com/ec2/instance-types/u7i/

Thanks Michal,

It's worth fixing now, I'll send a separate patch to address it.

-- 
Best regards
Ridong


