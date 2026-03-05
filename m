Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D078EFCE58
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 02:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3789A6B0005; Wed,  4 Mar 2026 21:51:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 326506B0088; Wed,  4 Mar 2026 21:51:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 228AA6B0089; Wed,  4 Mar 2026 21:51:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 101876B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 21:51:31 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 95AEE1CB42
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 02:51:30 +0000 (UTC)
X-FDA: 84510483540.23.3BC3D39
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id 61847C000A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 02:51:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LBCRf6Ry;
	spf=pass (imf22.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772679088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ce9EqtabjAdAeKefFLUq0trgFug3kHXTicrfkTTmTdo=;
	b=IqG0FOspsLYe+u+rT6xe1mkryLdnwyjc2jBNBRlSuUFZgOFwy/pWXHxiHXT7kT3+ZZOLbo
	rtmIGTMpKzuvcOpdH8ykcMjMHB04DbdkkZc8+CoAfc89Po5w7xuT86wHvtiP2vf/jIZ3Lr
	RFJMBqKdPGe6bYHGCu2ZDxl7xB3vRxs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772679088; a=rsa-sha256;
	cv=none;
	b=zUaPTk7jQIGnHYHfCYQTWIup34FPcZWzgB7sUdOVnqgmKmx4Oyi50ihBD3Ng7BqXdfXDuy
	HKUEMBwknaI0Pm/IYRYtq6Iul7CMVJ4cGB/8P3LEUkfaA/g/b/oM5E1xRTYdS5fUDVjb3m
	kOKI7FCzlXzw79nxhsiWLLHEYdVheq0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LBCRf6Ry;
	spf=pass (imf22.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <e44845ad-47c1-4b9b-a553-2c3054bf05e7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772679085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ce9EqtabjAdAeKefFLUq0trgFug3kHXTicrfkTTmTdo=;
	b=LBCRf6RyiS8eBOAANfyDQJkIyNmgHJRCV5zdDo2BMV2WQs2MdxHm9tbG3KWUom8e2GEct/
	zCqAXSVJhZ1fKkCDrlsPfUQNnPzy0W0kJ0yRPtPF4Yfcwge4RlkOhCb1aXHFE7bBsgkKOC
	agVRYflly/5+l2og3VSmMtmlKDYl1w4=
Date: Thu, 5 Mar 2026 10:51:00 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 update 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yosry Ahmed <yosry@kernel.org>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <20260228072556.31793-1-qi.zheng@linux.dev>
 <CAO9r8zNYFvNnz_oTu10kPBYL6=1ZewKUMRYcMmcMdSqbro_miA@mail.gmail.com>
 <de1476aa-20a3-420e-9cd7-9238efd3c85f@linux.dev>
 <46bgg2vwqvmex7wtk2fkvf454tqgaychb7l4odnnrx7svci5ha@vy4b4ophm763>
 <22cca07c-49e0-42e8-b937-7b1c7c51e78d@linux.dev>
 <20260304140656.10c524970519de373accca0b@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260304140656.10c524970519de373accca0b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 64yufecxjjwgbhc8hx55oqnx5ihkzxuo
X-Rspam-User: 
X-Rspamd-Queue-Id: 61847C000A
X-Rspamd-Server: rspam12
X-HE-Tag: 1772679088-790067
X-HE-Meta: U2FsdGVkX18njosJn16bkHOOwjjyj61P7SzqPWMmNPh6pUu4MAWJQgOmODkwn7n0rDj/mpwzZ7SKqLdULRVkyNdQBar9dODqx81I2Z7BV1Dix50K8VbEQijrMltmKEEONrII4RzTLHYssBzMUdmSZVKgK7+ZR9Wv2lzNi063ElvmPjrivPKC3vEeHxBpcN7SgkGnpg/uTXA5J5aNNY3bn5b0WLo8mE9jHt72462KUdn7Zbm6fK/VR/BzKM08/Fp3g/A3nHV+oKjrqtf0gA5jElxhc1NUanEaR/VcrYG3MMj1uGkr+f2H8q8oYaTibFfn0nEZfLsZfME6lgj+UBuRAeRpfKAcRMr5/nWytxtkfKY+B6qTUPtAIGy+e9//dK9dSUfvQNnx67brjO0VnG8L1goMwEqf1YPS7sSo2zm/cyhKKIfvZIZ0N+2JGGqP72uYvu1gvVqRE73xbpFD6ybco+7VzvKMurK9HP3OSiv1yBguEr/DKci5Vjtf+NNuxdodW8gWOs00Mmyi2k34RTB9GP6PRtliMLIbyyRiaSD0yRccEIkXZDAk9vJFrS5lhqEgCn8Gs49ZMHPcFvkMQszByuYyraZ0G5r7hTNF9PbG1LsSY54Ii+7tbebwV+k+FPsHHlJG3YPc7bj5KuF0eDjYHF85WOinuq3LMUWsgy0ham8mn47FU14FohM00G3aMdaZ0QLZL/3M8g8bRGc76TWM0xn35idl+bYbjGMswp9x8/STcGpYKFv4PXGtF9wOdu6CNK9Mzjhp5s3GRJ2Ix4otB/CU1mv6inWtg6Up8Pq453aUufZA/mcjruaC8v1YG7CGA8wsSvatW8MCTI9tzE+ejfwrGBoxDzl0OiWzrj2Cw2EdUkGaGs7MR9xdhZNSwCDmK+YmySYGaunhw6eWQFvDlLLpMvehEAQszrVj8kDUYtLMeVP00f0VLcaoKVLbqF5YGKGrg3pqmOLzkHIZHfQ
 O1qhwEjY
 8LNvoJnajbQliZHf0DFL71c8dlLwU8LaGa2AMtPWrMf7HFFLTGJtJ/U/Ch20o0yggOBniQHSQQAYhE1Qqkom6HTeZuZDm0XOZzGZAhF29c4BrpkTfHvKcOHCavrIP5JpiCRFqj16WaW4nFaEHegc7AbaIc+HrRu727dm3B3EHO3oS/t2CXXDqn/SsB9l/dknV73apgsScXLU6rYyB1buPUysaKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/5/26 6:06 AM, Andrew Morton wrote:
> On Wed, 4 Mar 2026 15:56:42 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
>> --- a/kernel/cgroup/cgroup.c
>> +++ b/kernel/cgroup/cgroup.c
>> @@ -6044,8 +6044,8 @@ int cgroup_mkdir(struct kernfs_node *parent_kn,
>> const char *name, umode_t mode)
>>     */
>>    static void css_killed_work_fn(struct work_struct *work)
>>    {
>> -       struct cgroup_subsys_state *css =
>> -               container_of(work, struct cgroup_subsys_state,
>> destroy_work);
> 
> Lots of wordwrapping in this patch.

Oh, I will check this more carefully in v6.

Thanks,
Qi



