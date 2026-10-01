Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 588DFCA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 10:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FF036B0095; Thu,  1 Oct 2026 06:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D6096B0096; Thu,  1 Oct 2026 06:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EC656B0098; Thu,  1 Oct 2026 06:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 18CF16B0095
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 06:54:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9E1C416039C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:54:32 +0000 (UTC)
X-FDA: 85273748784.29.B4EB747
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id CE8991C0003
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:54:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A+oM44gq;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790852070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aA5+KUvXhlWCHJtSM04hRod0BwqPg5dVCGPChHmxQ64=;
	b=dGIBN5pVV9V7rjt7DuJ6VimVB4lD5m5FihOs9qlwlIbzr5fhBn8FkowFW7mMUZVfUD1D1y
	4qcGgnES4CF2Kbdnma+99fIF4331zh+ddZ+Gk+sjBFf5AvBnWsOlSuFhnBrpooQFY+jwRh
	L/k5tW+tjnOsSNQ4tmYCPLsTzjJmX2M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A+oM44gq;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790852070;
	b=D4QP9tcOhRj9kr1ZLWfOUWTpTucrtH0H/wfIUF/z/hWi7OGAOQygCOuwpdMoafG+s6bSLx
	VA+7T0fgF7lMRzxOBsaTqAde2szAOe5mrPrepjVZ5YODoM5ES82HYsPfNbhHV3mMun8Ou/
	0iJaqnfdOV5dbY/2SDdxePW1FtbRNTc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5196060A55;
	Thu,  1 Oct 2026 10:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F131F000FF;
	Thu,  1 Oct 2026 10:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790852070;
	bh=aA5+KUvXhlWCHJtSM04hRod0BwqPg5dVCGPChHmxQ64=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=A+oM44gqAYtQIxMXkPx3vuoESBuPYWQv90ZRpAAmF/k2fw72YwnvZU9sAwYzrF5ol
	 rkZeB2mLMSbAIHg0MmKlEMev7WicLbHN2AXJ6HnRVnWJRG5s9copv4G1it0PkygtXR
	 sqdevmRv6fDk8KcOXg1ckPYQhxld0P7g85MtBWlb76ldKs6pG7jlrb7SrdQnTl4I2Z
	 EjFWA5oxsTwuJ5bsIBsJR+jQlLup3RVP7CGfqgwF4ieRFcf9zAFPJCMF5RgiO7JBeJ
	 naCFF4fS4WBY4K+8rGVdxnw9btIGppzKqrDIK8rCBFdCSuTMpQj0ssddunds7v1PRj
	 vnqKMlJhVjF+w==
Message-ID: <280965b2-c6eb-4f01-a0ac-c4fb7e518f97@kernel.org>
Date: Thu, 1 Oct 2026 12:54:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference
 with MPOL_WEIGHTED_INTERLEAVE policy
To: Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>,
 Li Zhe <lizhe.67@bytedance.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260930121154.687586-1-joshua.hahnjy@gmail.com>
 <2e3f12b7-0dac-428c-b70b-07e1f63de028@bytedance.com>
 <ar0fURbLDPrphYMY@gourry-fedora-PF4VCD3F>
 <A005B05D-A85C-4153-A65D-0BDF9D8500DF@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <A005B05D-A85C-4153-A65D-0BDF9D8500DF@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CE8991C0003
X-Rspam-User: 
X-Stat-Signature: jw8fgkwwwojkmre6ieq97jk8a97hfihu
X-HE-Tag: 1790852070-751562
X-HE-Meta: U2FsdGVkX18DPO8RMOTJNk5Vbz+vrbm5tBPCdjZYmi88AZu8leHMeWYSGGjuYsr+tTRzdZ/yx44UVDTBxzqTo9+8oSQsH9ck0ZM5nSXlrrVZ2YefGur+9lWNVRnl1eKPLIw3qu4RjTvtbpzec4Dzfq6l7EPCYwXdsYaTnH3dTpCsfxZrDuJqsGr/9H3g5wFEhplnP7tcFCb66lW30TfrBelSjtgoj/hCu6agLEncq4pzv8Jz/w5zte6boVLYqtl0h+FBnPCW9D0SLoyot2c70E2UocYMePP/G8PqbAa6z6apSG1Z1DgGvj9e5CRtVTN4II4iXEnL5tO2MXAfVeB2ermZEqXOvDlrlCIxL/F8f1WexQTvRzcYu2Db5KQXs/oIiS3r1Cb1QOvlcvdXyK3NoXQJP7swTXAqEb0vjGQt4aX5PAS5jzxM13qezs4yjIihdvc3rBMx4KjHabGUEkWuzODx2a0Fllkr8mToEoc8Wm4Qb8y3mYmayB73IuVUnV4wD36Bg25XGK41j2KDTkvl6nx3vKSC/FsgQ+AaLmqL2IXQfNpxSMorDQS0QywVOSSsC4GQdXYqkx62CpIB30mAH9Hrc8aZDo+3B9EPm4NCef6zEiULO8CusNndHAtAxe7rnEsmxhnv1y9TVEi0Pb4eA3FIk37dJ+eoekKpG9CJA4d0Pp2FVjD+nBpO8G2Ok2V7d4/OqNa186HNvhYtlIrH8pE3LU9cRK49SZb9j2mb7Xz8AtPADeyk/Dto4WY104m/19CSaPigEDf+WrbH7b98hIjWR24zvoFHJt4gFLF+s18HbBwtWF+gtPf2O4MQxMAAqN3rxwJlRYXjp4SJXwICG2fOBOEr8SWKEmVQ8kUxyGyTcxC7QP9xXv++OIFkTsa6vTB1iCzZwN7us5HwenXd2B+RvrcambIf2Ic6t4ycNBzazmf5kquzmgeMspFCOKBI7VX9sGy6W8rHpLKvQo/
 CgE11e6K
 2X8G3RCvPP4slHDEZfPiOpVBYaVhcBzSbhWga+j8b9fdA/cI+nGYnLTz70U23dUiV9Oiei4+qwrjSCYLKfBSB7FeqMKgnxoh7M+Q1PelVBts7WspRFb1stWwOjakfK1gW6esYl3p6DTzWbWqXTGxqqxoKTx/sgVkfaTzOTTJdvHkxlx1wpNmiXKHaaVn0QqV/2Htz0Iu/pWUspFMXLBNap30SvryixgoFuHErd5f//Xy9dvORAgBMneUSrO0NI1quQ/qXmsHJuqg/jqkD3QKVyRt0zvVgtFyrjmx0JUx68fThEtfhJUQgtJExfkxJDaCKkZcTm/rnHjBdr+AV/wBV0MwODB91MNh9Anzj8o8LtUIKTUcCTyfxfj9C5CD+ksxNXu0jIbdpkSsP8vrON/BBdJRkBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/26 17:10, Zi Yan wrote:
> On 30 Sep 2026, at 10:50, Gregory Price wrote:
> 
>> On Wed, Sep 30, 2026 at 10:02:23PM +0800, Li Zhe wrote:
>>> The use case is closer to the second one, but the main motivation is not
>>> only startup-time performance.  The more important point is that each
>>> workload has its own DDR/CXL budget assigned by the workload manager.
>>>
>>
>> mempolicy is the wrong interface to do budget policy, you'd be better
>> off looking at Joshua's memcg tiered node solutions for that.
>>
>>> MPOL_WEIGHTED_INTERLEAVE is useful because it lets new allocations
>>> follow that per-workload budget from the beginning, instead of placing
>>> everything on one tier first and correcting the placement later. This is
>>> important for workload orchestration because the workload starts from a
>>> placement close to its assigned DDR/CXL ratio.
>>>
>>
>> This however is reasonable to me - you'd prefer to spread out the cost
>> of initial faulting placement explicitly, rather than simply take
>> fallbacks when the top-tier budget becomes pressured.
>>
>> i.e. w/o interleave:
>>
>> [node 0       ]
>> ^^^^^^^^^^^^^^ alloc until full
>>                 vvvvvvvvv fallback
>>                 [node 1          ]
>>
>> in this scenario you end up with considerable hot memory
>> on the remote node consolidated in time-space (everything
>> allocated after node0 becomes full skews heavily toward
>> node1)
>>
>> Tiering then likely takes many faults to rebalance after
>> you've already reached node0 limits.
>>
>> w/ interleave
>>
>> [node 0                                      ]
>>  ^^^vv^^^vv^^^vv^^^vv^^^vv^^^vv....
>> [node 1                                      ]
>>
>> In this scenario you do an initial fill distributed by weight
>> and then let tiering figure it out without consolidating all
>> of the pressure to the point where node0 has no space left.
>>
>> That said - this seems like mostly an initial-fill problem, after
>> you initially fill your memory, a new allocation largely implies
>> the memory is hot - and you probably prefer that to be local.
> 
> If this is a initial-fill problem, can userspace set weighted interleave
> initially? The program or harness can observe memory usage of the program
> or related NUMA nodes and switch the policy to numa balancing via
> set_mempolicy() or mbind() without MPOL_MF_MOVE after certain threshold
> is met?

You mean: use the weighted policy initially and then switch to a NUMA-balancing
one which doesn't involve the weights anymore?

That makes more sense to me. Although I struggle to see why an effectively
"let's put random memory on slow and others at hot" is a good starting point to
later let if be fixed up by actual balancing/tiering.

It all sounds a bit hackish. :)

-- 
Cheers,

David

