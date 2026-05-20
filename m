Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86AAACD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 08:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4F4E6B0005; Wed, 20 May 2026 04:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26946B0088; Wed, 20 May 2026 04:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D632F6B008A; Wed, 20 May 2026 04:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C581C6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:40:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 908A4A022D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:40:12 +0000 (UTC)
X-FDA: 84787151064.27.2FEC0A0
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8A535180007
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:40:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779266410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jfvF8sLabcE4e8ODCI381BeizvS77iFHLpX6h6B4eMY=;
	b=jURnfOQcmyLqDdnzuJiU3HuvFtBjeF19qTx28CyKaXEW5R49dFExAPm7gfP5euuoaCBcKw
	dzbDRE1nbhkrP/KwQZVtN/9xKryXECovlAtfqC2jGVbnalTVlS/4blonb71KXKzXZEliE/
	BIj3mrgc4QQ4K1uyv0BYZJTTyarv0Fc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779266410; a=rsa-sha256;
	cv=none;
	b=iPj+OccxomK8AwzWyf1Ta/LQKXl3K34sHkRQMwURy409a6lr7vh57OASWPDUnh+NRGxqs+
	rMXFuzKtNIHIltnfGp9zKqd3QSuRQVdpeNmNNhInR1KCcxGzhuGLJO1PIU7EVAVNBaGyut
	VL3MwCLT1UKKAFS3iFetDTiyfSLquAs=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 3B0D83EBC7;
	Wed, 20 May 2026 08:40:03 +0000 (UTC)
Message-ID: <7e28d0c9-80f2-420b-87c4-55e571071059@ghiti.fr>
Date: Wed, 20 May 2026 10:39:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] per-memcg-per-node kmem accounting
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Minchan Kim <minchan@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Barry Song <baohua@kernel.org>,
 Kairui Song <kasong@tencent.com>, Wei Xu <weixugc@google.com>,
 Yuanchu Xie <yuanchu@google.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org
References: <20260518145732.349196-1-joshua.hahnjy@gmail.com>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20260518145732.349196-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: dmFkZTEDCWN8I9KCg3ODolESpoO8C0U+cgp1vdclwRT2FiWCsJP7mQ/S9Bk8bA5NqEjt69Syv/4OrmyY/GmF7OFXH1yz8GGHmlYmDFs4jgE1XBqREjezj8hlgKNMnNs72ohK6EA2GZ2E5RPntNL87/W0nt5zBFG0+xw7QqNfkdAwc4tT7jRdEcCPGnB1uMvnnsOx84TrsZM7hZkPrJoN1JUdrQoRFBx6DyR8vzq+aLH4NeF1zVnrJhBoblpOLBNdvQXsYvqnvirnSFLqmUQvg1lDnoos7/pwu6cvE9D82wj7zvtmBNEMiJTu2MTmAO0J41ksYyF5yPOhx/97qhbUHAPbsTUDRXIfJvFjwzjr0fCXWdzPzwW4vSN17Jsmqu3qtcVYRaEWMyx2JgoEjbSTzqQxzO08jmV9FjF5OJIc8KuQsxBR3/Nwx7PHE80/GsqTip2bvGdUvn/CMsMYFFXuIidw8KtNtlvOGqdASvgLB3/awxO5Zg7QQ+Pl5KkFYrCV/IPtO5g9zEuNlVn97nCp2j6nI2HoUrOnDmGeS9jWlWYSkPrk7ZtfM9xnBh8f9vVwbCtef9A3C9rVvrmMSglqMCPphLm+ssH9O+IBcsjLXWIRSfKLIvUqUmhQtqyHEjIvMMF/qZRPdmcKDGynf5t4YXC6xpDmLg6useSeWmxvWB+nJJxEnw
X-GND-State: clean
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A535180007
X-Rspamd-Server: rspam06
X-Stat-Signature: pr7c69s7fm3g1kuouu4hxx3pxph16c6w
X-HE-Tag: 1779266410-512466
X-HE-Meta: U2FsdGVkX18vVoe0zbKxc6xxD369IexW4UxVu1ltyYL7XAImEaglGQ7QVyqdkckMceoPFV6SsAp/1uSNFpkioMBNq+9cmRI8YcQNaVSifS4MHqKJCAOmuOljSJ3vXvRb4mLFZQ5NAgmbzAIhhHUjONUm6uGV+55P4FptR2Nm3C8UZGXpYuQ00sr++mmfvoSS8MCpvwvLpeA3lssliHMXMLlwuuIAiu8leiACNQ11HGhr8/lxD1szeuEiXh2wZOCkGi1fjzkipiV5N9l5Pxyqn7EGLmOlWO1PjVRB8PFHfKOmQqMNP84Z0oIAX6zVugRFoadDaXtrD6JMKkwuCclDACaz4whDYMcHDl94Nu1YdEVIoT8+os1HjsLk+GiZ/zDbklXmsGnK8xAFucNmqYqFZ8R29g4Kwbt1VaNJFi3g59JkFSQBr/I3wmVjRHfBv/oxRcB395TDc+Iu2e+qyJWerTH3ZifItAGTOo4R4UQ0nNwh8cem3Zvx0txNinlb/Cu37xkGtZBvbcgaUiVgoe961Z7/QuYZRuUm2tzbyfTYqLjRIfUuXMQvgFhI/yl8R494U0i8r65TOaZXTAQ44up8QHfryGToPiIAsKr3OnMJ5YXH53nqQ+rJVRfZZmEBGGpUMH6SzG5w25OSg3Men/2Nufk7EZ3zBjnXf1nyRltLbQbrlFSJw8l6wVsOw8eVuoz/dIHFRhkO5/jfvyWzzhHiV3K+uC6t4/CBajn+uqOhpobxY3tHWR3fjA2YjjicP/3g9XK9UzJw+z7VsE93d1pM5J1T1FbcnkZyRUz9pCWJAzNcQ+F7KYhvR54wDo5tGj3XSKoJqbusdqmPwHSQGP9/ZwjA/oiMQpT+1lYXHOLDKK/rA7RL6/7c5TznI58xuWXw3iet/RcIiuYp8m0NXo5uNMPHvoG77sGpinpWF5mLC/t9NeDTTbf7/l0c4kwIR0Hsb+uQWzpM6HYXG5IaUGK
 nkq5zZD0
 cDBkXSwrTOm+2lVVKFphdNIQQQAdE0L3DhyWgJTIhzWXuD9dqJGVLWDt/7vIyyTmcdPcjKj3028sWVZG4fvalQ9/O4QxAH4aNhzvORE42fxr1bnAWjK2eeMfBhBc3yBWCbabjO2TxlNV0u+wJJ04TVilVnmvS5dWWfIenzKggcFBSdVGkK3BSJcN4ZLfpop+BCluRAiN2AVtu0DbC9WtCVVSw7pdP+WFt5vM4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Joshua,

On 5/18/26 16:57, Joshua Hahn wrote:
> On Mon, 11 May 2026 22:20:35 +0200 Alexandre Ghiti <alex@ghiti.fr> wrote:
>
>> This series pursues the work initiated by Joshua [1]. We need kernel
>> memory to be accounted on a per-node basis in order to be able to
>> know the memcg and physical memory association.
>>    
>> This series takes advantage of the recent introduction of per-node
>> obj_cgroup [2] and makes those obj_cgroup tied to their numa node.
>>    
>> The bulk of the series is percpu per-node accounting: percpu
>> "precharges" the memcg before we know the actual location of the pages
>> it uses, so charging and accounting had to be split. All other kmem
>> users (slab, zswap, __memcg_kmem_charge_page) are straightforward
>> conversions (zswap support is limited in this series because Joshua
>> is working on it in parallel [3]).
>>   
>> Thanks Joshua for your early feedbacks!
> Hello Alex,
>
> Thank you for your work!
>
> Overall I think the direction makes sense to me. Pre-overcharging makes sense to
> me as an approach, we would much rather overaccount than underaccount and
> later have to breach limits.
>
> I do have some concerns on performance, though. Namely, I think there are
> some expensive operations that I think would benefit from some performane
> benchmarking with this patch added (maybe some simple microbenchmarks that
> demonstrates kernel allocation overhead could be useful).
>
>  From what I can tell, there is some additional performance overhead that has
> to do with iterating over num_possible_cpus() x pages_per_alloc, which
> doesn't seem trivial to me.


Indeed, let me microbenchmark the overhead on a large system.


>
> Another concern that I see is the stock credit system. Maybe we could be
> bypassing the stock check leading to more time spent doing the atomic
> operations.


I'm not following on this one, which atomic operations do you see that 
could be bypassed?


>
> obj_stock caches a single obj_cgroup, which means that if we split the objcg
> to be per-node (in patch 6), then the obj_stock basically gets invalidated
> every operation since we iterate over more objcgs (even though we are in
> the same logical objcg). Maybe I'm missing something?


The objcg split comes from commit 01b9da291c49 ("mm: memcontrol: convert 
objcg to be per-memcg per-node type") and the problem you describe is 
exactly what Shakeel is trying to fix [1].

But I remember trying a microbenchmark and noticed a +5% regression (on 
top of the 67% then...), I'll rebase this series on top of Shakeel's and 
re-run.

[1] 
https://lore.kernel.org/linux-mm/20260520053123.2709959-1-shakeel.butt@linux.dev/T/#m127d4969b105c046a2a21e3c79c963771007583d


>
> I haven't taken a deep look at the implementation details but just wanted to
> raise some high level items that I noticed. Of course, all of these concerns
> are just theoretical, if you can show that the performance delta is not
> noticable then all of my concerns don't matter.
>
> I also want to talk more about the local credit system but let's first see
> what the numbers are first.
>
> Thanks again, Alex. And I really like patch 2 because it is a solution to
> a problem that I ran into in my percpu tracking series that I couldn't think
> of before! Thank you for solving my problem too : -)


Great then, thanks :)

Alex


>
> Have a great day!
> Joshua
>     
>> [1] https://lore.kernel.org/linux-mm/20260404033844.1892595-1-joshua.hahnjy@gmail.com/
>> [2] https://lore.kernel.org/linux-mm/56c04b1c5d54f75ccdc12896df6c1ca35403ecc3.1772711148.git.zhengqi.arch@bytedance.com/
>> [3] https://lore.kernel.org/linux-mm/20260311195153.4013476-1-joshua.hahnjy@gmail.com/
>>
>> Alexandre Ghiti (8):
>>    mm: memcontrol: propagate NMI slab stats to memcg vmstats
>>    mm: percpu: charge obj_exts allocation with __GFP_ACCOUNT
>>    mm: percpu: Split memcg charging and kmem accounting
>>    mm: memcontrol: track MEMCG_KMEM per NUMA node
>>    mm: memcontrol: per-node kmem accounting for page charges
>>    mm: slab: per-node kmem accounting for slab
>>    mm: percpu: per-node kmem accounting using local credit
>>    mm: zswap: per-node kmem accounting for zswap/zsmalloc
>>
>>   include/linux/memcontrol.h |  27 +++++--
>>   include/linux/mmzone.h     |   1 +
>>   include/linux/zsmalloc.h   |   2 +
>>   mm/memcontrol.c            | 150 ++++++++++++++++++++++++++++---------
>>   mm/percpu-internal.h       |  16 +---
>>   mm/percpu.c                |  90 ++++++++++++++++++++--
>>   mm/vmstat.c                |   1 +
>>   mm/zsmalloc.c              |  11 +++
>>   mm/zswap.c                 |   9 ++-
>>   9 files changed, 242 insertions(+), 65 deletions(-)
>>
>> -- 
>> 2.54.0
>>
>>

