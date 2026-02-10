Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA778E9462E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 03:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B5F36B0005; Mon,  9 Feb 2026 22:13:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 160926B0088; Mon,  9 Feb 2026 22:13:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062846B0089; Mon,  9 Feb 2026 22:13:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA7456B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:13:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1A99B8915
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 03:13:00 +0000 (UTC)
X-FDA: 84427075320.26.D6D995B
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id B5E3240006
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 03:12:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tw7AmvSd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770693179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yubXWpReL8k8hbkA3y11vW86dPL2+7IUWmPBxrke92U=;
	b=Tr7ly8OqZbS3tYWi9zUoJ6FbVfB8D6kJtYfP8mVxB73cZFH4wBNVXcL4B4k+huXmu7fhWw
	xFMebYDt8WO7EEgnff87VPAzQR2oO2/PJZkoev6tHwrpxH1vyovAFtk84M8plDA1E+OKo+
	YNBOMEQ5VyB3ALKLLCl3t0klzkJVP7o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770693179; a=rsa-sha256;
	cv=none;
	b=UtkiH9ONCpS0F+4F9BOk5xyvsbgWCOJt02+wK7MxPMVpmru9BbTOCNtsOf1Xc9DkDJy/Gw
	XGLbQjY+a16z4XoyL+DZvU/VW8IiAfXQsZTtnH94RumGpTY84UDztcGU6zbBHKgBaM4/Bj
	sDDa5rdnP0ExHR93U+DY4ubbwKk9qNQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tw7AmvSd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
Message-ID: <37b79f65-7de3-483a-a675-75eab94d2776@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770693176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yubXWpReL8k8hbkA3y11vW86dPL2+7IUWmPBxrke92U=;
	b=Tw7AmvSdFVwfbDs8VZgjXs2x8ddtNiTMeickGrjOWzTBV6Yh/PrtCcJVPvlHTiEQT4idPm
	PsZ5jlhuAvA8/s0ojPGTXRbI69ELL4rTgSgyXh5Cy+vx4TIoBa4afdD4iaqP/FnrhFCIUY
	OjMtGYUzjzSSOBP26w82VxQkWD8+BRw=
Date: Tue, 10 Feb 2026 11:11:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 30/31] mm: memcontrol: eliminate the problem of dying
 memory cgroup for LRU folios
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
 <9e332cc8436b6092dd6ef9c2d5f69072bb38eaf6.1770279888.git.zhengqi.arch@bytedance.com>
 <aYe1R2MMcXbPVYUW@linux.dev> <2a0e4ae2-457b-4d16-a7b9-7372fd665337@linux.dev>
 <aYoezZdqL_AofUgP@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aYoezZdqL_AofUgP@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B5E3240006
X-Stat-Signature: pxfguoh47hksxb3g176mqpijh1aak7bo
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770693178-984998
X-HE-Meta: U2FsdGVkX19/tF8MtIl7BfdwY3HpDHSRomlCzGZzP2fZ0d+2PxW+TPBVnPLPTwmGVup+BJjUltui1PNyAAqu+YSO2b/FNrpjxiTKmZIdUjHXn3XnJgan2tCY5fOCqStAKjhhi16SvcqMXIGmN9GsMBjv//cj1D+a2d/8unYhD1wF9KXPs6nEDaHHHS892CGwCuiqr1moW3/Y36wq9/mP/OxLwDUBLmDc53LZliyV/gGCh0DqhaUcORrP5p75hK0REZhX5MMRLEsl/xZI8PqmG1jks4wt/aBz80MoFqSa5CghaeOIJCU7yqGTyhuzz9fBvFRDb4ibi7jtaM4/WxiokzjiZe1DOZqECat250tqkAj/KvaPovuKF/uRFVl0B+5XuEOcTCemDQ/8jPXwD6szGn0vDbbFaSAwcNIWXAx2/2S8aXjeuz4dNwZqPkurgFfdpdgH5VDM7p0qnqvSLoMbV0eT4Se+T8WjliFazRueZtHpWVtLjnkbyw866SjPGYjh61ZjBVq752XogcugJ0onTvfvfJR0LR9miRulymSt/JOBAFm5HS5MOGSAnI6yzBiaww1pdzcdJZQ+zjOJYqbna1qUhARD/W6RzVqr/+J+3/rM2mj7mPNAFGlA98dTxV0MjzHqzGLILGWMK7VMg1XY7pW3Pwv30InMDm5oNIxZfeMHy5hP4SywOAo5rC/MF+spwsCUt1y9Hxwr8pt5MnxT+/h4h0/eg5PsT+PN5bgTpvUlVHw1NzXwqGiY4INtaTHnaavPt/UaLiGI32hAQviP1PbOOMgTK2jngzSLDT73pKMQ+AI5yJI3qaiDNS7SGbwgTSUHCLNg1ki8FomUIiWzJi6OOcCWtkZWaGZqmmmFA42MpdVvFxKrRZERGIzPRvUgffhe29K6oCv7A6yFf9x7QAi8PGNqx5nsk5NREm/fCtzA2qf9dU5jV7g5rSV9lkQpumk2I+ijYgv2EHOVW10
 Ykli/2Rb
 nIBlUbWVD9ruHP/2zkKx+z20YcK5h+/dUshmwoSYzpIAAJkHEMkNA2IDkyQK56jS/hq5nebMa86Mn3q+ztz/BaUR27L7ieYuO8X1SCmB5nqs2hUPDQ2DK5e8UV5YcOX5HX8XifnboIZQYPt6vOYs1EunfS0j8UmI+UiNmrplvZ1qMX3ua5VbrgMsR4fSodR+FQSsmeILwH4D1H2c68kq8+iz/ZyR/EoRN5l34aU+biDzIR85/ijGLEhEqj2fk8zTYSklkw8/CWMtrUmY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/10/26 1:53 AM, Shakeel Butt wrote:
> On Mon, Feb 09, 2026 at 11:49:43AM +0800, Qi Zheng wrote:
>>
>>
>> On 2/8/26 6:25 AM, Shakeel Butt wrote:
>>> On Thu, Feb 05, 2026 at 05:01:49PM +0800, Qi Zheng wrote:
>>>> From: Muchun Song <songmuchun@bytedance.com>
>>>>
>>>> Now that everything is set up, switch folio->memcg_data pointers to
>>>> objcgs, update the accessors, and execute reparenting on cgroup death.
>>>>
>>>> Finally, folio->memcg_data of LRU folios and kmem folios will always
>>>> point to an object cgroup pointer. The folio->memcg_data of slab
>>>> folios will point to an vector of object cgroups.
>>>>
>>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>    /*
>>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>>> index e7d4e4ff411b6..0e0efaa511d3d 100644
>>>> --- a/mm/memcontrol.c
>>>> +++ b/mm/memcontrol.c
>>>> @@ -247,11 +247,25 @@ static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgr
>>>>    static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
>>>>    {
>>>> +	int nid, nest = 0;
>>>> +
>>>>    	spin_lock_irq(&objcg_lock);
>>>> +	for_each_node(nid) {
>>>> +		spin_lock_nested(&mem_cgroup_lruvec(memcg,
>>>> +				 NODE_DATA(nid))->lru_lock, nest++);
>>>> +		spin_lock_nested(&mem_cgroup_lruvec(parent,
>>>> +				 NODE_DATA(nid))->lru_lock, nest++);
>>>
>>> Is there a reason to acquire locks for all the node together? Why not do
>>> the for_each_node(nid) in memcg_reparent_objcgs() and then reparent the
>>> LRUs for each node one by one and taking and releasing lock
>>> individually. Though the lock for the offlining memcg might not be
>>
>> To do this, we first need to convert objcg from per-memcg to per-memcg
>> per-node. In this way, we can hold the lru lock and objcg lock for
>> each node to reparent the folio and the corresponding objcg together.
> 
> Oh we want reparenting of both objcg and folio atomic. Let's add a

Right.

> comment here with the explanation.

OK, will do this refactoring and send v5.

Thanks,
Qi

> 


