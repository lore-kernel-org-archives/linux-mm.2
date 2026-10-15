Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85847CC6B1C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 04:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77EAC6B0088; Thu, 15 Oct 2026 00:09:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707FE6B008A; Thu, 15 Oct 2026 00:09:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9E46B008C; Thu, 15 Oct 2026 00:09:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E9776B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 00:09:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D5CC21C3BF9
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:09:48 +0000 (UTC)
X-FDA: 85323532056.09.6FFF72F
Received: from va-2-111.ptr.blmpb.com (va-2-111.ptr.blmpb.com [209.127.231.111])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8110620002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:09:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Oei178cR;
	spf=pass (imf03.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792037387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZRj2GAZqXT54HVtNDIUND68T2cWL0CDUpFdwNDt9C/c=;
	b=QxbXpnhpfC40cN9vRd7r4allhAV7SmuTFblzIJl0hB0eK9sLollZzKOIoIk2qW3b5dqOEJ
	B/M9mXmHeJvVAGOI85eVFsMBkOvgRcql5Kwnm0Iqd74aLIUF5pcpR8zd6h8e+b8iUAh+Hd
	FYI7LWXxYcnGMcUdKQAt2dA7VHQN3Bg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792037387;
	b=Icj0PFxA6lw+xxk1RyrhYUD+AwAM12Xa3BdCchn3gpEXikZs3svj81a5gmaz5rxLY2T7u2
	7rwQ5wuWetYC7ddxrvlZclkNLIkmvbtwmK1dH2o8lE6+r8i/nPf7JtcUSJT6Oat9MWXDIK
	0bApsHugNn07rSmS8nem/ffejrKABeA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Oei178cR;
	spf=pass (imf03.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792037381; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=ZRj2GAZqXT54HVtNDIUND68T2cWL0CDUpFdwNDt9C/c=;
 b=Oei178cRmt4vFYunYV+nz2zYtcJOdySv/VpwVa+HnCmkfWrMeUVWCQ1+Q64g/UIo9oSNxl
 wfXlLAOeCpZfRCRxh2bJHLSkV4PtOiz0UvVqUlUxbSage3FEQG9M2mLZxhB8Qx5ujj1CY8
 IeRVuMcxf5YRPImNqkrtgNYqCa8e6mBVIh2/SgkVcN2rl0NBjJaktlOed1H8bTnFs49ost
 Ux+6tWmGIZk90EOvrIgpD3UvK1BUWevxq8Gf6k227grE1YvrDwhBG9Jy0bG9cOvfYNMYRo
 /nleHmd11clal0/S/mmfYgO8aH8LJppW/S4G7YFZ1v7BbGf+kUDlNtuq7QFxKw==
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH 4/6] sched/numa: make free-space tiering promotion bypass configurable
Date: Thu, 15 Oct 2026 12:09:17 +0800
In-Reply-To: <as-AV04p-AZ45-mw@gourry-fedora-PF4VCD3F>
References: <20261014094347.99157-1-lizhe.67@bytedance.com> <20261014094347.99157-5-lizhe.67@bytedance.com> <as-AV04p-AZ45-mw@gourry-fedora-PF4VCD3F>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>, 
	<joshua.hahnjy@gmail.com>, <ziy@nvidia.com>, <mingo@redhat.com>, 
	<peterz@infradead.org>, <mgorman@suse.de>, <riel@redhat.com>, 
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>, 
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>, 
	<vschneid@redhat.com>, <kprateek.nayak@amd.com>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Message-Id: <a01ccd5a-f443-49bb-a615-5712881ee7cd@bytedance.com>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: "Gregory Price" <gourry@gourry.net>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26ad05203+e180a4+kvack.org+lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: 8110620002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: wtp194wwesoz5e9y3sey1erhjsbtfo91
X-HE-Tag: 1792037386-633771
X-HE-Meta: U2FsdGVkX19hfJeEJw6h8EoDSzPZ+gknzosPjTn18u/3/2/MSUEQf6KUP8jeJiv167lOsiAI4SCqxK1ihzGiHdYcYuewkok/m/dFaSuJW2ckAISTLz9tQeI9XTcAiMQ2LEcK0yMcw30rwp89lY58pKSI3VzmgckTYrhO/t+w4MSQMry3n14FkQYpAPzT4hYIZcYT3onkivfndukUFWWTARG/uuer0ogWG3z28GnoWKpwdkpEDjTRqVJNZQGN4J22/O4prtzLJWaPhTnIH6Glv6BawmzwH5rF7Bnpg6xNS3+36trfqYm2/IhkYrPbnR7iQr4A6A6lZxs/BhBHOIUwG8sVwqhLq/C9sH9r43K0QMCqsNJWZv9VOssNm9eRkTmLXZFya0vLVKkB9tfLvVqvuhJZgXaZyUSZ1XUb6O6Bfcf12mZvjs7YX93oUPwtWzv0a6vO6abhOueK4O8QiM7EgqE0LLJFdDhuUMHS1T8A8T8c5z5JnJJ4ZYPzNvg2hL/+P/GSsyZh1LlHtnmMzIQkxl+nW6EdlGhzEaPLbZZKw+HIpiIvrwfwBRnbPFgB+WeQvoyXc5cnQW1J4tNUzAfDF2GGGPtogCLV2HjQ76qmEaHjfT3nbkdzY4vZ2XSzPdLUmx8CkSSaXih7U5pz21PZ/Xl3+22P/fMyIiDPJMjta2Gq8chr7VllqNVbqcy47FSW22jmGVagi4Td+XFy/ahzkKwkPmTOVZcfqJidxmOt5lzzQlj1o9FN1Hqro6dS7pwjeIgVQo9yrlYEdTgAJBYgHbg2N5w6LQaHu0910RAbR4aSU2TiwM9oc13/ViKHz5ZBk59LNUFFdvNhjknwfGs2Tr2Fxmxw7yd2Tv1UNS28Kp7zaSUidsP4vSl68J1F/3JpklriWxT3db55dpneQau0UcUiz5YLPnsebVbiQmSOzu0jyeq8PWHUFI7fTACKZjf5tDzeAgH3Ng0hb+BZYTn
 KyjTHzGi
 oYg7dvdtFgu0G+g85/nt1pjhM5z2Y70JyBT/9tNFLMgJ5TyUAa2uTpSyKckc8F0PAsEnaZ9uM2I1Ek/8tNmQSbJbRK5X2b5UywDbXPAJ2rK2nyWNE6ARUmCqgkLq4uB0kaGorrW4zcwI2OPIvbrqHtY0i3WAnka4/9GPXmgzSccXntr4LKBk8OBrQMH3y7MObhTb9jA7m0/W8scsP38BxSwcGhrP2L8UOFtDvidkikWgT36BWREAOxlebBPbjSkOjLp86F0lkGTzCxYCCOUMRducNUqT8WcM3vKMr0I4IRu7KZ6NT/V3vfBD6jotf79RHQJtAlzxvyltvOhjsTw6xMn1dgBr/jhMJ9yMBev0e9vO3C65+ZZLNbK6jmpzeRQY/WE1L40VlZsNCUiA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/26 9:16 PM, Gregory Price wrote:
> On Wed, Oct 14, 2026 at 05:43:45PM +0800, Li Zhe wrote:
>> Memory tiering normally promotes any recently accessed slow-tier page if
>> the target fast-tier node has enough free space. This preserves the
>> existing policy of filling available fast memory before relying on
>> hotness and rate-limit control.
>>
>> That is not always the desired policy. Some workloads may intentionally
>> place memory across CXL-attached memory and DRAM to use aggregate memory
>> bandwidth. With the free-space bypass, cold one-shot accesses and bursts
>> of hot accesses can refill the fast tier and pull the workload away from
>> that distribution whenever DRAM has free space.
>>
>> Add kernel.numa_balancing_promote_free_space_bypass. It defaults to 1,
>> preserving the existing behavior. When cleared, enough free space in the
>> target fast-tier node no longer bypasses the normal hotness and
>> rate-limit controls.
>>
> A global switch for this is a poor solution for this problem.
>
> Also, if the memory was spread out intentionally, it presumably was done
> so with a memory policy.  In that case, if the user did not set
> MPOL_F_NUMA_BALANCING - that spread is already protected because the
> mempolicy overrides the numa balancing fault and no migration occurs.
>
> I don't think this is the right direction.

I agree that a workload which wants to fully preserve its initial spread
can avoid MPOL_F_NUMA_BALANCING.

The case I had in mind is different: the workload wants to opt in to
tiering, so hot and cold pages can still be adjusted, while keeping the
DRAM/CXL distribution meaningful. This is the same kind of use case I
was trying to describe for weighted interleave plus NUMA balancing:

https://lore.kernel.org/all/20260930072617.64665-1-lizhe.67@bytedance.com/

With the current free-space bypass, opting in to tiering can promote
recently accessed slow-tier pages without the normal hotness and
rate-limit checks whenever the top tier has enough free space. That makes
it hard to combine weighted or interleaved placement with tiering
feedback.

That said, I see your point that a global switch is coarse. Maybe this
should be controlled by a per-workload policy instead. For example,
Yafang's RFC for BPF-based per-cgroup NUMA balancing mode selection seems
related:

https://lore.kernel.org/lkml/3eda489898ebf7c848ce61760af745d9@kernel.org/

Would a per-cgroup control for this promotion behavior be a more
reasonable direction than a global sysctl?

Thanks,
Zhe

>
> ~Gregory

