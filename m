Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A49BD3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 09:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6C136B0088; Mon, 29 Dec 2025 04:43:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C19C16B0089; Mon, 29 Dec 2025 04:43:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B256F6B008A; Mon, 29 Dec 2025 04:43:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E53D6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 04:43:41 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F8438D95D
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 09:43:41 +0000 (UTC)
X-FDA: 84272021442.29.7F04118
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf05.hostedemail.com (Postfix) with ESMTP id 53A6C100002
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 09:43:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ep0ofLr6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767001419; a=rsa-sha256;
	cv=none;
	b=HdG2dfdOcqwUGz04yaUHor2diLqsClhp+4NCG4xM0NQ7LLKggjCBpGGNsHB2qai96o/h1j
	hstBLHhgW9/M3dBEOja/55ISlt6Q+4Xd8P/LQe64VwVkhZ0cCeNF9BXK6P54dIc9uk5aBv
	CZWpfTp/7O0lBk1OGMPkQcbSHB21wdQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ep0ofLr6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767001419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R/8bkRxwLhm3ndKDh76WkE4jKqSh3LbyQvzuDAbsOlM=;
	b=B50dRqTR0LGhfDmrwWjF7eqCGoVdrjTVpssjwtd/Kq8RlRHGx7JD8z8xpdiMoSawwezVED
	qci90QkrPnJ7x2sk5eydZbesDvAxsBAWQ2cZ0wWKxDBbgkzK7qlW7H6o2+G/ZMFkhGY+h1
	LlT1GmnBVX8esjJcJ1G0q42XuO/fFnM=
Message-ID: <63c958ae-9db2-4da8-935b-a596cc8535d3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767001414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R/8bkRxwLhm3ndKDh76WkE4jKqSh3LbyQvzuDAbsOlM=;
	b=ep0ofLr6pd8c8v1hSU8uzSTuUae86JeEgrGad/Usy5m+TaFg9AbILVCgricA9EQxhQztga
	hnQK8UO1IlUNKQigYM9mPWcp7oIRwo86HGXTdSPTzKWPSEfCWpPZhFFbey5eRatOTRc/xO
	nucjZrAolKE9xzD+8R8JxFysEuAPNxM=
Date: Mon, 29 Dec 2025 17:42:43 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
To: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <5dsb6q2r4xsi24kk5gcnckljuvgvvp6nwifwvc4wuho5hsifeg@5ukg2dq6ini5>
 <vsr4khfsp4unk73a75ky7i35nzdjqsbodyeeuxipu3arormfjr@awi2srdwawfu>
 <utl6esq7jz5e4f7kwgrpwdjc2rm3yi33ljb6xkm5nxzufa4o7s@hblq2piu3vnz>
 <7enyz6xhyjjp5djpj7jnvqiymqfpmb2gmhmmj7r5rkzjyix7o7@mpxpa566abyd>
 <llwoiz4k5l44z2dyo6oubcflfarhep654cr5tvcrnkltbw4eni@kxywzukbgyha>
 <wvj4w7ifmrifnh5bvftdziudsj52fdnwlhbt2oifwmxmi4eore@ob3mrfahhnm5>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <wvj4w7ifmrifnh5bvftdziudsj52fdnwlhbt2oifwmxmi4eore@ob3mrfahhnm5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 53A6C100002
X-Rspamd-Server: rspam10
X-Stat-Signature: ws94amdbg6rbbfxf6zx5rwoid3xpczxa
X-HE-Tag: 1767001419-306629
X-HE-Meta: U2FsdGVkX195Odm5XScIjhlzW8GAcBOl5vFj3yB6YW3PdgXgz22tnx/47QgERiFAB8V4gJ01XqmlawAFHAUfDBRCu3ly9myRMHu+Z7oNO+QRktBi2HU6K8fG28yVz++FXjPk1ympTL2mzjHPorHPHhCDQ1adSJBmHqrwZLT2GxC2rbB4pRhak9MLD7Ip7YxvPq0nq716wJgyeIh9jzaBRJ6vDjA37GlCcK7fDRXiVi/ZsgN2Rfiq9S/6Qk0nvsGtA1aej8QnPmZO0/M8CVViYnZihox9/JgkD5OYB2L9FVwhiDsObGSklcWUsvJTF7w08gvVPM4gwrNx163J+nYyiIya6Qauv0WuWl2KCL3hgt6LhFqlPzR/fZIpGvOxH4WZIQbW9k+koAamPPdY0CAnnClIBXrnGZwFvfcD5rNYojH7DIV85/7X6FHyPxFjzJm4KZChGhAhkl6lNksfvlLyKqftm7nWFFFiO9Nxp5/JCdFveFnLPlZjPwkPIt3Iq4abaFq70cIlGaoabxfT6DtR0l6pWRIatUjwfw3ndwRdilVcwHo6+XoH6eGeSlbHEjN+o3iP+414Gs0FkkFOzrJVMy5fj6f55BVjWEtDv/xgtx7r2Yzkos+gdUhpwrPgEz9OAoJtFeBRxdw+mwrGrTe9LbmlIcS/TS+6Z6tYUDP2jGLpvkMYlgZXMmZwsJwyQcxMHv5XzS03WTpwv3x2VOPaK/m7QpR+3w1JSTxHhCPd3ZfgcR8zzJLHgqoRFiN6XZq7/r97l5v/gy860ikHmyOjZjEyexkyIbil//QocUh4x29q5Cdh51MDZ/074g3uycWtv98dheWXADhgYTrbtczEZGTF0N3HAsfcgBkLIz23LsViKj2Y99nq0mspMUGJ6yneoXZbwHCy2wngL0NL7dH/4JGYgcf9wlxMNjcg1v4h3OWLovEDz7Z/4vJBDy/8La+4BS2GAGvlc397gk+RcqP
 isrnnp7C
 ymCkT1YpxryfiQpVtY02Ec4PUQx1EPpMd7MRUoQMztFIg5/6uOQvYfqlOlCbbfGoRWKoo2hSTt+ArcxbnK4d9q/qk3hO1rLqbl6W4wR4N10ekTD/nzYXPnsPMOSlAb59ccHBeucA4eUMkowbFv0ZZuI187BGjIWHFyRFEROLAoEo+ORvmu+Z6jteQiNnYKHexXsSJLny5bgck9hz2R5GTwEi1Mg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/24/25 8:58 AM, Shakeel Butt wrote:
> On Wed, Dec 24, 2025 at 12:43:00AM +0000, Yosry Ahmed wrote:
> [...]
>>>
>>> I think you meant child's memcg here.
>>
>> Yes, sorry.
>>
>>>
>>>> before
>>>> reparenting, and using it to update the stats after reparenting? A grace
>>>> period only works if the entire scope of using the memcg is within the
>>>> RCU critical section.
>>>
>>> Yeah this is an issue.
>>>
>>>>
>>>> For example, __mem_cgroup_try_charge_swap() currently does this when
>>>> incrementing MEMCG_SWAP. While this specific example isn't problematic
>>>> because the reference won't be dropped until MEMCG_SWAP is decremented
>>>> again, the pattern of grabbing a ref to the memcg then updating a stat
>>>> could generally cause the problem.
>>>>
>>>> Most stats are updated using lruvec_stat_mod_folio(), which updates the
>>>> stats in the same RCU critical section as obtaining the memcg pointer
>>>> from the folio, so it can be fixed with a grace period. However, I think
>>>> it can be easily missed in the future if other code paths update memcg
>>>> stats in a different way. We should try to enforce that stat updates
>>>> cannot only happen from the same RCU critical section where the memcg
>>>> pointer is acquired.
>>>
>>> The core stats update functions are mod_memcg_state() and
>>> mod_memcg_lruvec_state(). If for v1 only, we add additional check for
>>> CSS_DYING and go to parent if CSS_DYING is set then shouldn't we avoid
>>> this issue?
>>
>> But this is still racy, right? The cgroup could become dying right after
>> we check CSS_DYING, no?
> 
> We do reparenting in css_offline() callback and cgroup offlining
> happen somewhat like this:
> 
> 1. Set CSS_DYING
> 2. Trigger percpu ref kill
> 3. Kernel makes sure css ref killed is seen by all CPUs and then trigger
>     css_offline callback.

it seems that we can add the following to
mem_cgroup_css_free():

parent->vmstats->state_local += child->vmstats->state_local;

Right? I will continue to take a closer look.

Thanks,
Qi

> 
> So, if in the stats update function we check CSS_DYING flag and the
> actual stats update within rcu, I think we are good.


