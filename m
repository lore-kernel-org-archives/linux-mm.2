Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7045FC43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 08:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3236F6B008A; Mon, 29 Jun 2026 04:21:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D9F46B0092; Mon, 29 Jun 2026 04:21:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 175E56B0093; Mon, 29 Jun 2026 04:21:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D97BC6B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:21:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5747D40509
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:21:55 +0000 (UTC)
X-FDA: 84932256990.21.3CA3A53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 95D25120010
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:21:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eJM17GOj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782721313;
	b=sRs0YrsYWRPYTGsVvEHx4Met7G6nLefJc71EuOBRMx72/zyt6Lmc3ED2Z09XFYdrP2w6qk
	VqX7Kj8PKyS88m15mezBmbGGrPLQrxDWQWikVvdANutUafor2NcxUByxMiKdJgJACiHj+F
	bMKiP7q099g/lLilIBQPv1lt7hU8/1I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782721313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PTgXkbvVLbmjixblka4EX/WB3VrVuB2RapiXZ8W+wIg=;
	b=bHISADb/5MOXPCoEVpSGrtUJ31zQ6YCWqxGWSrUoDu3Ir8MSr4UqPuNOlIhCe4D3/YI6lX
	RS/G/FiNFG05bAw1H1U2ajSRzLclxsbrKvw5r5hYz0BrZaYkvpJ1XupxiuxeTv3UfplGWB
	OTEfapRoMtRRJ8hOp+7yDkrETL1/flk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eJM17GOj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 22F146001D;
	Mon, 29 Jun 2026 08:21:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59D11F000E9;
	Mon, 29 Jun 2026 08:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782721312;
	bh=PTgXkbvVLbmjixblka4EX/WB3VrVuB2RapiXZ8W+wIg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eJM17GOjQPe7POwFKir2rKmQvXq1KG08ah06Lp5zlKQ3rzcdympN++OKKa2ZVsntv
	 WTQC2r8gNLJclFMRpjNVhWgB3qqGuos9yaea9mmVHx/HvYLL1tYLsPlNNedCSiau3z
	 A6eL0rLU0obT2P+QtewXrxyf3zoEYRktkL43EYOZ2YlAfHg/w9m1JkST9DS69NqUOS
	 XMXRTj7GOruKPSgfEp4epYL12ulnANdMWVLsNJHGTLMep2UW5WAzOG6cS28huhaMUy
	 r37erDxj9w5NjwglaiWEy56P9PIkxcjhLKOBLSrw60geyFBz9vGd0Eel4WigqDN4Wi
	 4FAENakVFTM0g==
Message-ID: <4709b993-85aa-470f-a346-2c3ea36bc4d4@kernel.org>
Date: Mon, 29 Jun 2026 10:21:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
To: "Michael S. Tsirkin" <mst@redhat.com>, Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
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
References: <cover.1782676497.git.mst@redhat.com>
 <akHUboUaYi-OJHFu@firstfloor.org>
 <20260629033608-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260629033608-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 95D25120010
X-Stat-Signature: wh16pwr314s5fhjr5peuqy714fho19w7
X-HE-Tag: 1782721313-710047
X-HE-Meta: U2FsdGVkX1/OHFn2kkmkdWM+418f0NeNCmmE8qOUMXpYTH/1fKs7YAYepPJ20CUZHwBEdv724RjWQWH4duxp+ZquaF7Ug707aPBZ5hkOKztCOeUP7Oa8LG/EGEaVG2GrQUhsp3gu2XLlcOjEpXtaoVCsPR0sgisnYanTbJBaQg8Y+h9aQPWmAZHTnnbG00Nz6msB+QSLQZC5xtqcw+0fuyKGBDx6FjAQ6FvZj5JqV26OgZAsp+aRKr0GiCNVz6qMOIjwp895YiL04uaNNrmlTuoCfJP/ZyS/kYI8+aBA1H2UjCoedYkUA64Y6BhrR+ALImLfncKGtCjGLt3Lq4hAvieyPERcdB/LJXHsoscfi/rDrHWIdRAaqEYBWXjApQ9e1cNh7+gs9K7SLdKC4fOQPzux7SMehGu3eIMeXguq4sYK9Fw2T7GwR3aQ69lz+JZH+drLweymyU+rSgJywCKYvWzxicsZfcU5WXCnb3yEBJYoPbRWJnhAzRuEiJ7RBIvcBKdaLeQp9FY50KDZeLVO7dVERXo3hz5T10fbcGjkcbtdzSw9j/qLu9uaHsLAVSzlDGYagjOzm78ap7qPXXFl+8/FC917Z/kE1iK3CcfQrq4bCNcJdp0netJDN7O7MYTQTf7jLhGazpmuBkVHNPWNyMKH9SjUQ5oZrP7hA0krh+VgdMYmTmTIBc7ud7gLkO7Vx4PriCT3HYbpwaqLnBGDrQYH/8ApR2xOG+g2cwqTy6SySfkzdT/Qn+gNJUAvzm3fpDElXU+5w1JM8qp1Jdx4kAn3xhz+J1tfZwqN9vCFyGFtmou7/O+bguZU6L2mFa3CNWdvwyZfYM0rhZ9yE5cS7rHK/COu/c/hnve1s4tbTjEX6QIK85gQ/1PGmecyv0n7BgNPb2CWBkyntTso/ZVeg1yR3L9qrXPz4ng0InCHnK7VkAn7HzPrlPxWkCFq55Qd6aUOLwkIdjrHCBh64rf
 xv0l2Eyy
 ch3MocLFwlMUjbbTw7XJlrVEWz8cEiFfq1Q1BUOH0GoAGLMW0Gjot06K2kmPxu/Mb8e+bkEg/brXy1OjdwfB7E3Jq2a5zi+MoyGZ3c+jHf9bJAYI/s3q3zv3GYPM3LcdWXDg8ntOw48peLpXu3nMKNnJCw6EfciWJEScP2gUDZCGU5zSpcKZVc1YWOVTlK3j9fa88pESBK3Sk/3hm+6gtwj3SNMikwGS3salqo/efyL4+UeTqu4Ki+m3qxGa8elU9VCk8vFSMvitZ4dzBRrnoMfEchkzUR1OC1jljYRFJHXUHYuTjO4etHBy5nE6q9M42Xbr5qVytJqHerCb7kXa8ZLql0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 10:10, Michael S. Tsirkin wrote:
> On Sun, Jun 28, 2026 at 07:11:58PM -0700, Andi Kleen wrote:
>> On Sun, Jun 28, 2026 at 05:45:22PM -0400, Michael S. Tsirkin wrote:
>>> This series fixes the race by:
>>>
>>> 1. Having memory_failure() call synchronize_rcu() + retry after
>>>    setting HWPoison, so that any in-flight non-atomic RMW that
>>>    read the old flags value completes before we proceed.
>>>
>>> 2. Wrapping all non-atomic page flag operations in
>>>    rcu_read_lock/rcu_read_unlock (CONFIG_MEMORY_FAILURE only),
>>>    so that synchronize_rcu() actually drains them.
>>
>> It wouldn't surprise me if your underlying performance assumptions 
>> -- an non contended atomic is cheaper than a rcu_read_lock/unlock --
>> are not true in various CPU/kernel configuration combinations.
>>
>> Modern CPUs have fast atomics when uncontended in normal circumstances.
>> But it probably doesn't matter much either way because the difference
>> shouldn't be very much.
> 
> 
> Hmm. It's a bit silly that I didn't try. Seemed clear to me, but,
> on this old xeon...
> 
>                                    insns/iter    cycles/iter
>      -------------------------------------------------------
>        base                       12238 +/- 1.0    17889 +/- 97.9
>        rcu_read_lock              12251 +/- 7.3    17991 +/-191.6
>        atomic ops                 12233 +/- 1.9    17733 +/-136.5
> 
> 
> The diff in the noise.
> 
> And old, slow CPUs maybe don't have MF at all.
> 
> So maybe just atomics instead of all this mess.

That would be much better.

What I was concerned about so far was that many distributions enable hwpoison
handling unconditionally (independent of any specific CPU!).

I recall running experiments on some not-so-dated hardware 2 years ago (when
optimizing out rmap atomics) where additional atomics really hurt, even in
uncontended cases.

> 
> 
> 
> 
>>  It seems very complicated for something that
>> could be much simpler.
>>
>> But I guess it's fine.
>>
>> -Andi
> 
> Indeed. David already said he's gonnu look at this himself, but he
If we can go that simple route (I'm not sure yet), your patch would be fine. I
can try finding someone to run more experiments on arm64 hardware.

-- 
Cheers,

David

