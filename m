Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50309C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68E516B0093; Fri, 18 Sep 2026 09:34:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 665CC6B0095; Fri, 18 Sep 2026 09:34:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554586B0096; Fri, 18 Sep 2026 09:34:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 36A776B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:34:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E70D160699
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:34:33 +0000 (UTC)
X-FDA: 85226977626.16.1F0272D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 930AC140013
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:34:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fb+oI0eB;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789738471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=79tuBX9NtcLOFHYrVaZYnlXt+W9WU4j9rmTOREA3oT4=;
	b=Ws7zsmTTRJXSah9ad1+7VZ0xDQutkcrnEWM+fnx6CEXhAHL+2wK8T2UcVOz3bDXHn2Wn6H
	DAmFGHt0kAphbPA4ZHiFfLeSDxeRfYFpV7S173RatbzjHzsMAmeZUrsZr/tiF6IQ2D5ZhU
	N1sYg0zBBF4BqGx0u4PcJGo03neH8iY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fb+oI0eB;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789738471;
	b=SuogJcyzMrm8T2hdPX+71b0SbC/vYKKMHU9w3PxGLBd7/6KCzQzvR8XgpWFF3KXDLHQQLe
	JTuQwMthZBRpHvzfkHowk2m+eWAMUvi0T0iRGDl/W5BmM7E0KTRYROoeQH4+TO2cnMPSjG
	O+9cImCO5CI3aYt32I2djUuRGbJByyU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A0D62402F1;
	Fri, 18 Sep 2026 13:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F6C1F000FF;
	Fri, 18 Sep 2026 13:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789738470;
	bh=79tuBX9NtcLOFHYrVaZYnlXt+W9WU4j9rmTOREA3oT4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fb+oI0eBop/lWoz0ykKSm5KiAODDbkMzthqi5lEDcZbXhmawKdxmvKUZlrMSLL5PS
	 WnA4FFrXioEhVBwA/MDsJY3AvT0V/VcNxZGboSI/HOTbXyGdUVwkxas/74LSk0uii/
	 zVpzGzSl0rfU9bcw3B7zmujjcecVRAWXkcOOBSTTajJjH8Nd/rP6DVvByHPLOHVa0N
	 3R8JwhT9IA4e9ASMFqsqD1iZ4WW1ME2waj267TBw8inlQpPe/fhUuST5M5u0KGhXGy
	 fctI61XJdFcOmj6F+pJIuEY0soaFsU4jtbhkx4uCEHngq7j1ju+2uNyZgrl37M6S92
	 CUmJa8kRXhh4g==
Message-ID: <82da5375-bae0-4a12-af2c-de82d18769e1@kernel.org>
Date: Fri, 18 Sep 2026 15:34:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm: memcg: don't hand out large folios above
 memory.high
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, ljs@kernel.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, xlpang@linux.alibaba.com,
 liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 chris@chrisdown.name, kasong@tencent.com, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260915042546.279410-1-qinyuntan@linux.alibaba.com>
 <20260915042546.279410-2-qinyuntan@linux.alibaba.com>
 <aqx5kcqRrbkuay4i@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqx5kcqRrbkuay4i@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 930AC140013
X-Stat-Signature: tboq9r73ysmh3xqjnmd3a7d49ywgix79
X-Rspam-User: 
X-HE-Tag: 1789738471-700721
X-HE-Meta: U2FsdGVkX1+U+gTZwzrEuqCcOUDBqWuORClDqqfshxz8cgdMP+UX7o2HeTtd2JvqT+2xzrjWAzx+WUgM23lAT+lWxQuE9MrOqQoaCBTy5qgs/klG5oeOliQoA5xMUsYfu0PXTKoKi3/60wpyby0myZZx6AbP0cU3OqXQQhSPPQV+lKIKsjb+anjeOE3nOYMFlyR6stV6DJrFK04VeZmJLpzYtBDCDRhhgD4sz6IOUqSiWaxGQlSqRkT3hnsbjL8ygSPlxIDqox+IxbWo5iUJFkij9reOAkCo2jRl7HLvkWCn3J3L2kXZNsgrQOpcdNP2qnjuV/kbMFDhGeeRnbi3eIiBrHt/CpYhnOrSyiwiQT5y7RFRUElZzMn4thbpTXY57Q8g5PxF7JI2U9Ao1OwF6jciUhOJo429cgNvBS8h9K0hGOIFR2TnSQ/n5Prul5tyFIrgPKF+OfF0FnACxNfrvK1WqO9eoVzVrAKFFvlLB7xIoIHVmlwlzSLSsRoGWpqB+gZr9189C5J/VHIKldabKAy2KqLPT79+cTSFjbR6VAPRAL7R5TF4MJn6ZriJRTKwft/1OUktY+EXbHAKxy8r0hakcsIAtJVv7TFOPu4GSfxtXy04ZLvxOw7K7Wai5jEseeMh0Aq91vpjb4fcWBy02joYZrbL/khbZ58HImlVxkfyy0dPa4HHVyzq/g+MQ8wuzoaXe/5qw59ZrjSviC1ALwPayJABoELbLGSPHvIDK618bGLzB6MY0RAGupn4p4HpeL+zG6aiVcj9Pdm4ki38r4Efd2jiqq9sWLGfLm6qeHIvuF1GwKCf7bXz8b7eV4AXsAoz8l5wneN8+sDJmKxTcpgqhHvHuytt8znPJCsvteH/xgXxioivUd7CAaI2MG6721919UeQ4a2P4SfqfU+ndbvCw9mmLfuXCZgZLTGCciQN0M4ux2bFWjVfZoTvpvjo+BPASex/f700z6ibaau
 Cdv6Oc4F
 mHFhiaIvWrh60DjABZL/+wt4j1+y/tudvaZWLlXpddHuTXM3wUChY/ZDzpX9JiOHZHd5GKZGdubW2FAoviqHOhxgJQezhAgYM51xgnCmEKLjRSFujss6P5GnwF1izyn732B4cNAagPv0GMqr11966RlT8hr7NwM0dBJ5rAK6KG1YzWa/AIBz8KZOFMVIPD6YCYEui8/ME292lmyHGHZEFwuLZLx6KtHnbh2nNR4j3lgy1692neHCuMFro3WLO0Fy87jqr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 03:26, Shakeel Butt wrote:
> On Tue, Sep 15, 2026 at 12:25:46PM +0800, Qinyun Tan wrote:
>> memory.high is enforced on return to userspace, and synchronously in
> 
> Over time I feel like this sync throttle for memory.high was a bad decision but
> that is an orthogonal discussion.
> 
>> try_charge_memcg() for large overcharges, but only when the charge gfp
>> allows blocking.  A populate loop - mlock(), MADV_POPULATE_*, any
>> GUP-driven population - never returns to userspace, and large folios are
>> charged with the THP allocation gfp, which does not allow blocking under
>> the default defrag=madvise without MADV_HUGEPAGE, nor under defrag=defer.
>> So neither runs: usage grows from memory.high straight up to memory.max
>> with no reclaim and no penalty sleep.
>>
>> mlock(200M) in a cgroup with memory.high=30M and memory.max=140M.  Of the
>> 110M between high and max, the burst consumed:
>>
>>   4K pages                       3M in 5s, then still throttled
>>   THP, defrag=always             6M in 5s, then still throttled
>>   THP, defrag=madvise          110M in 13ms, then OOM killed at 16ms
>>   THP, defrag=madvise, patched   3M in 5s, then still throttled
> 
> I don't really like polluting non-memcg MM code with memcg internal details.

That's the same thought I had when skimming the code.

-- 
Cheers,

David

