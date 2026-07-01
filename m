Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1DFFC43602
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:17:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A82876B00AD; Wed,  1 Jul 2026 12:17:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0C0F6B00B1; Wed,  1 Jul 2026 12:17:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AEE16B00B2; Wed,  1 Jul 2026 12:17:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B39E6B00AD
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:17:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D9D731A0402
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:17:35 +0000 (UTC)
X-FDA: 84940713270.01.1366132
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2102E40006
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:17:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EzJnptID;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782922654;
	b=xt/LqfSzB5ncs+ovgiYc5Jgh/epMbKimbObbwLlYtqFirjj7j0Y470M2Q6+4RlG4Wg+yg6
	kYvS8PoMpRdfYmbXpvdhV1aI/aI0kJSOenFX4A8onIo0/XUfFicEA7ANHDYm/yeibrELQj
	+n+xdgf+VW0YF2MlS4XuEh/wfU8oj7Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782922654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uFcBNd60OaYA5Y+rtfkHScnnu+1+htBpNsra9XAmyzU=;
	b=Hx5XhbXoNYLQvxgbk6aFWQ/GJLVbTqnbgAO7dtIpMzWONAMNpCunxZJq9IbIDAzu8AlPl1
	74BUEvFzpocOfa96B0qFJminQj5HRaoP5ihhn6laulwbu2I6+uIoSPt3BWk9u+OJbTVpPe
	cB7ciIdoElRVz6mnDJHnp1EPNEwmDPw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EzJnptID;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CC5E601DE;
	Wed,  1 Jul 2026 16:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A6A1F000E9;
	Wed,  1 Jul 2026 16:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782922653;
	bh=uFcBNd60OaYA5Y+rtfkHScnnu+1+htBpNsra9XAmyzU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EzJnptIDY29oYgbo6yB/i2dyz4L1vuF8JsElH3OX1hkNA2c4PF17z0+BlHpyQKiGh
	 ae7zj5X/y9D4nGkzH5Ij4a7fHqonKNCax+j0zthiVJOQPXfYO12p4gvKJ9xg/5wDzq
	 qbvlUmMyUgmJN5tPHZBhaPv7GkDppPJJeby1UlHFf5xs1C/6wbKwvx8FYN5Bi5Pujt
	 bvyWOwEHEvTukWm2O2KQMsXycfN7T4T3Muhvb3wz5pLRs8Smsa07Srmjs/fbrwRYPR
	 kw41ba9ko+kHFD44hAdTNIDxW8UNr57/GaVaGEWIC20B/A58RtTttqiHeRPKjMqTaw
	 tLNdjf9+q5Hpg==
Message-ID: <a353c28c-a864-456d-9b00-7f6a932cda73@kernel.org>
Date: Wed, 1 Jul 2026 18:17:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Andi Kleen <andi@firstfloor.org>,
 Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
 Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org
References: <54c8cbee-9b26-458c-93ba-5aa594f5d1e8@kernel.org>
 <20260629174225-mutt-send-email-mst@kernel.org>
 <cbab829a-3e65-4b4f-a2e2-704e88a611a0@kernel.org>
 <f6d8354c-2f79-4a48-934c-cbeb335765e2@kernel.org>
 <20260630174852-mutt-send-email-mst@kernel.org>
 <2f884bfa-3cd5-4fba-8aa4-c2e68890ab64@kernel.org>
 <20260701041112-mutt-send-email-mst@kernel.org>
 <d2ce93d9-c3d8-4915-a511-d08eb2c1b374@kernel.org>
 <20260701043024-mutt-send-email-mst@kernel.org>
 <c03ec696-d635-4c7f-8c77-89a439d9135b@kernel.org>
 <20260701112946-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260701112946-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2102E40006
X-Stat-Signature: i4nahdreffpps4iunefeftmce631m1gh
X-HE-Tag: 1782922653-163680
X-HE-Meta: U2FsdGVkX1+waKU26Ne7ndImLH/yhet2Ahjo7vI39mA2AbtpBZ5Pyf2eAYadurY5RKkS/9j+bgu2ZUKgKiHOZKbRazKhTv2N0+ze571SMiaHTIqqoqXSPEcYHCaaadW9tBVujB4hn721vvI564bFindW2GlA06qcuevuePVR7hf0f2xTwlFGBwwkJm/i/a1bbYshChmQ04jJZs55C8oosc6PUDoT2vAPT29ibtAhX+Q/7L7IOojQpHuKGqAFs+raTy6qWxF+i7iBTkiHFxlIrpcQmwDEMQcwlqTVfjlID0LWRGvi5q+EHV6Okxsn9OrzsmG7wj9MPgoDmRN0/Xv2sKuS4NNwudI6eNuwrFV7xJ6H/Zj/bR74L0c+QJWJX5XkKp3Jomwskrc7Xf+AcP0L3r8hse5P470OARyly7/EG79eMnzPeRW0WDB/gFhEuhWRj1fYoO6SDsPERLKo6vDmuxsrdKab9ZQ0EBhde+J2Z1Fl60VsC5K3uzEDl32KyqPwQjyhwKv3x2uGaNhD5HxfBgLsgpzrmu0HmxC5RCNubA1q7gKfydD8rJzqLJDaO6BXpIvbqyu9rjwfr9nqLAt4MwCVhjpRo5vVP4ydcG92vZ+E9Az8uZAVc2FTNqEj+0T/HCQj5qx+61LOD+CSdAELgbNJH/wcgCRw11Rmv8ixMsTK8ROiVfa/8fPqYvWhv0VfGfzrE0ejW3ym4HubGpuRZ6kyDhsUP+t1O6+Uc15n2I/b2Xc8W6UPu4Jxdmzk84WUH2fHVarH98+YSmHRwmz5II82k/k7RCpyBrNLacDas9JVo+kzoJQRDopRjvSMQAA8PloFEhuS9Qed2cBdhRGzGlYKAFYqVCbvE8fAbSFC6t0Z5pZHU0RA0jEipT8gyI7nqdHu8+axvqTcp+6iFIPlJg/8qiUnMRCUjUI0eYRTCi+D+6IZvTnvIQnPD2lMotiCoZSoaOowmaEhO1w57yQ
 +0kP4va1
 4tRZHzChLJwrii5i0d4llxTZv4hGe8gWtF7FHLXk1myw/Pn8S87X3fPk6GB5JsQyiVivQqJz6YEhLAc11QBrNpa/rT1kaACgphOVQUgA0nDuKT4ou8HvqnpKc1sl/e88nlmWuPD/3ZEyUbMoiBlNNkN4hhY8V0+5+DuDs25WxUdLpxLHUGyv7kwKG30Ehhfmd+B4kglXY+5qlrnDIA8mikb+X+Cx+CaN8NsEY07hdeLYaPLUAQ0owq7hkAjRDdTEs83uMz76VFT4ADuVICzSH+PJFo1IDCWDy7yHIT/OjyLfxSkYyFijNLt4q6G7eRK2GJ5inMEWgV0H1tPXwQqE4uFOxRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/26 17:54, Michael S. Tsirkin wrote:
> On Wed, Jul 01, 2026 at 10:36:31AM +0200, David Hildenbrand (Arm) wrote:
>> On 7/1/26 10:33, Michael S. Tsirkin wrote:
>>>
>>> what do you think ;) post it?
>>
>> As RFC please :) [and if it's AI generated, obviously properly reviewed and
>> reworked by you]
>> -- 
>> Cheers,
>>
>> David
> 
> Not "generated" surely. But assisted, yes.

What I thought.

> Still hacking on it, but the difficulty
> with memory-failure is that fundamentally, it's not 100% robust.

It's all a bit slapped on top of everything, yes.

What I was wondering is, assuming the call_task_rcu() and it takes forever,
there might be quite a while where a hwpoisoned page that lost its bit is not
marked as hwpoisoned.

So you'd actually want the one doing the test_and_set_bit() caller to wait until
the bit is stable.

But that should be rather hairy as well. :(

> 
> For example, we have a fifo fed by hardware and consumed by a workqueue:
> 
>         struct memory_failure_cpu *mf_cpu;
>         unsigned long proc_flags;
>         bool buffer_overflow;
>         struct memory_failure_entry entry = {
>                 .pfn =          pfn,
>                 .flags =        flags,
>         };
> 
>         mf_cpu = &get_cpu_var(memory_failure_cpu);
>         raw_spin_lock_irqsave(&mf_cpu->lock, proc_flags);
>         buffer_overflow = !kfifo_put(&mf_cpu->fifo, entry);
>         if (!buffer_overflow)
>                 schedule_work_on(smp_processor_id(), &mf_cpu->work);
>         raw_spin_unlock_irqrestore(&mf_cpu->lock, proc_flags);
>         put_cpu_var(memory_failure_cpu);
>         if (buffer_overflow)
>                 pr_err("buffer overflow when queuing memory failure at %#lx\n",
>                        pfn);
> 
> 
> if there are lots of these and the scheduler is slow and it overflows,
> it's sayonara you have lost the flag, right?

I guess so. I assume on relevant hw you wouldn't expect a storm. But who knows :)

> 
> 
> Oh and by the way, I just noticed that when buddy merges pages it does
> not check the poison bit. So it looks like there's a simple way to lose
> the poison bit - have it merge with a non poisoned page.

When we poison, we try to take the free page off the buddy. At least that's what
I remember.

So I think we would just then go ahead and split the free higher-order buddy
page to remove the single page.

-- 
Cheers,

David

