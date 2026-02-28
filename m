Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63032FEE4C3
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 03:41:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FF956B0005; Fri, 27 Feb 2026 22:41:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AD906B0088; Fri, 27 Feb 2026 22:41:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18ECA6B0089; Fri, 27 Feb 2026 22:41:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 093E96B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 22:41:31 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C3E01409CF
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 03:41:30 +0000 (UTC)
X-FDA: 84492465540.04.F244BF5
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4B7C5140007
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 03:41:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SWuS4p0a;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772250089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C4heYZ2tE4N42LcNTwv/w/mLqT1Jp6f8zKyKbYhkIGg=;
	b=PdYiHC5hIoEC5RuzsVDFp/0TP8VSQPD5vRKardNloXd/fuk4IAD7WJgOOW5yPYqc/KlotC
	sfieAY+I/2qHcRGX/pT0Wkt3+iEw63JdA6Pabnz5aJNcT0UwXx9ESey9jcKcOiP7tyMV8l
	Y5dH0f4++sGz6IwYMvUVTnUGDq3lAnU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SWuS4p0a;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772250089; a=rsa-sha256;
	cv=none;
	b=hJItv+y/Cz35fpm+oxpRYLNf7Bz95dF6aKlTJtY4WcnELyNqoDzDvvXOOhsWk3EcBZWKkN
	CXNFJaJTigO9D/s0ExrGwOmaQYkXUBu1Nxc3snFVBSrfAG6zzrcnI4ODBtcg1dVQkjAf55
	eltZPFiFItOZ6pbgi29FyYmmXIaDlTY=
Message-ID: <8f230f3d-4005-433e-b91a-885d2a1cdc84@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772250081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C4heYZ2tE4N42LcNTwv/w/mLqT1Jp6f8zKyKbYhkIGg=;
	b=SWuS4p0a6o8LfHm6WUSteK8eCJ1R5+EemwAlJ0ubROwRHhF30Y3+j616kbWvcgMEMUUjSh
	P+hDK83K0ulySPL1tIA/G2VsGVgeWZqb6mdsty7dqxuQOfp0mlhU+0mrmFp5YxhG/KhM1h
	twirmqYmZ6XTYzXteXwii3uHdj3okII=
Date: Sat, 28 Feb 2026 11:40:57 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 29/32] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
To: Yosry Ahmed <yosry@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, hannes@cmpxchg.org,
 hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
 <ef13e5974343b37ae2a0e28aff03ea2d033cb888.1772005110.git.zhengqi.arch@bytedance.com>
 <CAO9r8zOhZgrym6oSrtg7b+HmNHEfWuAzZ0i8eYhm5-OEnfFLdw@mail.gmail.com>
 <aZ-R87JfacQ2gGq1@linux.dev>
 <CAO9r8zPmgytmGHAbueFKXcZWY5SJaEwD3Pqk99ws4XeO2_hnKw@mail.gmail.com>
 <97e296ed-ef73-44b7-ab68-3d79749caa47@linux.dev>
 <e15c2304-4874-4adc-bbe5-58ba78b3b84f@linux.dev>
 <CAO9r8zP-peywvtq-3HF2-PjCx9X_ABHEQF2vMO3OFoGfVOHTAg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <CAO9r8zP-peywvtq-3HF2-PjCx9X_ABHEQF2vMO3OFoGfVOHTAg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4B7C5140007
X-Stat-Signature: 7rf6zpfqx1pbfqb8pej6468ey3izwjyd
X-Rspam-User: 
X-HE-Tag: 1772250087-661581
X-HE-Meta: U2FsdGVkX19/28tyvYwQlZVGz9T+gHCN4Y9Hm12PVNCH4DVmNKDZ2bt2k7Y9g8RCY9ylg3bubGbkQRpAV8nc+j6kQIqBO9uT5jcbgaBIF6yZMKiJERmh0W7xmUPFaPoYG2Y022/0X/LehjuYqNiN2zeXf7OySkdJX+TUV7tMEr125U3mnpUpVZQmtvg78Fm/1DjzQFE4Hmtd7zqFkqiBJFtuoIc7bIWBMj0uEF5tW3CpZdVuAkKinFVx9mjMNoEejhpCePrhBdxwDWEGWjDlddcMwl9VwHfDRR7LfwgFVuHhfsJsI+bCnuTetnaxKoO0W5BuvNgUyvVc+XztWSEBFWV+Opzg6/pbVJuQaH6WPa+/CmKgqv9VNzk36aFV1BZoOkIviiacwv5HTbZP1nOEnGi6NPlGODJpCO4iGgIog6ZpBXY9mkkjL1jq+9wvay1zotctPMU4vr7GibLkeh4EQY2fTF66k7ON98UpdTwvptoAPtJOkgSP40+oQoc8T56KgF+6kRd7IIj05CN+YAOOnNBto41nSHr4UyzFdxWWGt5RIn+ERa9bslLZIPbVU9Eei07u9Uz9Wk8OhFzqkENyFGym/5ubpd2dK4bZeb+alZqkRlqOAnfH852BHp/ajaTfqTqggJ9Ei+4iBOwQuu1kP/LbiWvMVZo/E7OnuVC8d+iLBs11AKUx/nsmoYGwmoS3rvk0TFb+qwwaZw18tk1dPrKCYnryidQaIx7fwEoxf1ZUFyh/nRpTk5NEsI4aUB7PEU7piDufDenEu/Uz/diooobFTo/Aw+WtSruw/jOTBqYgoPmTRkBX7mbzGVBt0+gYeyHz969bb2e5ZXo5agRiPz9/Ub94AHn0PgBdimYlG3AwvM+mjIC4Jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/28/26 2:18 AM, Yosry Ahmed wrote:
> [..]
>>>> @@ -506,12 +517,10 @@ void reparent_memcg_lruvec_state_local(struct
>>>> mem_cgroup *memcg,
>>>>           for_each_node(nid) {
>>>>                   struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg,
>>>> NODE_DATA(nid));
>>>>                   struct lruvec *parent_lruvec =
>>>> mem_cgroup_lruvec(parent, NODE_DATA(nid));
>>>> -               struct mem_cgroup_per_node *parent_pn;
>>>>                   unsigned long value =
>>>> lruvec_page_state_local(child_lruvec, idx);
>>>>
>>>> -               parent_pn = container_of(parent_lruvec, struct
>>>> mem_cgroup_per_node, lruvec);
>>>> -
>>>> -               atomic_long_add(value,
>>>> &(parent_pn->lruvec_stats->state_local[i]));
>>>> +               mod_memcg_lruvec_state(child_lruvec, idx, -value);
>>>
>>> We can't use mod_memcg_lruvec_state() here, because child memcg has
>>> already been set CSS_DYING. So in mod_memcg_lruvec_state(), we will
>>> get parent memcg.
>>>
>>> It seems we need to reimplement a function or add a parameter to
>>> mod_memcg_lruvec_state() to solve the problem. What do you think?
>>
>> Since child memcg is about to disappear, perhaps we can just add value
>> to parent memcg without handling the child memcg. Make sense?
> 
> Ugh yes, I missed that, thanks.
> 
> I don't think we can just leave the child's memcg wrong. Aside from
> the fact that I would be nervous if access to those stats is still
> possible after it's offlined (e.g. can userspace already have the
> stats file open, or maybe some in-kernel code uses it), there's a
> bigger issue.
> 
> When the child cgroup is released, css_release_work_fn() will flush
> its stats and then it will be double counted at the parent.
> 
> Maybe refactor the part sof mod_memcg_lruvec_state() and
> mod_memcg_state () without get_non_dying_memcg_{start/end}() into
> helpers, and call that directly from the reparenting functions? Adding

OK, will do.

> a boolean argument to mod_memcg_lruvec_state() and mod_memcg_state()
> will add a lot of churn, and naked boolean arguments are not ideal.


