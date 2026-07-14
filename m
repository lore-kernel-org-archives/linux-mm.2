Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBBF1C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 09:52:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B33526B0096; Tue, 14 Jul 2026 05:52:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABC796B0099; Tue, 14 Jul 2026 05:52:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 984A86B009B; Tue, 14 Jul 2026 05:52:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B2CD6B0096
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:52:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0E541C02B3
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:52:32 +0000 (UTC)
X-FDA: 84986917344.07.3E643C7
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf28.hostedemail.com (Postfix) with ESMTP id 37867C0004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:52:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="QC/nN3ic";
	spf=pass (imf28.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784022751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l3zdQsCZaeg9r4pCa6BdAIjCC8ytsze0HKxR9F1SBpI=;
	b=0RMvx4g3TV2LxKEwefJjcKQj2jcvW9UC9g6B/woLnjq3QA1WNFfR30wKaYO9J1BOTlJytG
	7VJjAGuDW4qzMykg4mQJ7xdIF9ykC0nfOsvO+EOMJPDHAOxiHryknpuo2nTEn5+SdMCB7y
	Rh7FHayUsAEp0os1sTbf/wG3ucr063c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="QC/nN3ic";
	spf=pass (imf28.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784022751;
	b=Pdrsp9LTE6prdes/9TVKJl+ESby6AATKb9ZpFKUrY0W/dHbcY96wApQ4sMPVKSJxa1jR5s
	DAIV96b9tExQLtpKfgA5AkNRhr4Ke+gjgUsYExFNifiUhoWnqigcKCZxv4ToJvbh1WUIVM
	JmTMGq9qXhO+sgLsoPb9AvzN2laJ0+0=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784022749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l3zdQsCZaeg9r4pCa6BdAIjCC8ytsze0HKxR9F1SBpI=;
	b=QC/nN3icWHmag6UJtqg2N4KQzscCFcQB7nlwAt+o5I5fXa2cZ5qZoeDepf/8E+iOG91z7y
	bMSoa929x18iPeIt3YIWNGzy55z1kb8yd//PZAPapzJoedeJ+/mLkVCzRmoTakv71qiQ4G
	kcZ5BMeEHTubiMsxntmNtQQiAVyNav0=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Jul 2026 09:52:12 +0000
Message-Id: <DJY7A190TSH2.B1XHHIACRSYW@linux.dev>
Cc: "Vlastimil Babka" <vbabka@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Sebastian Andrzej
 Siewior" <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "Alexei Starovoitov" <ast@kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>, <sashiko-bot@kernel.org>,
 <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm/page_alloc: don't spin_trylock() in NMI on UP
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Harry Yoo" <harry@kernel.org>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Brendan Jackman" <jackmanb@google.com>
References: <20260710-spin-trylock-followup-v1-0-affb5fe5ed00@google.com>
 <20260710-spin-trylock-followup-v1-1-affb5fe5ed00@google.com>
 <20260710170311.e22bfd21c658e8357ceddeec@linux-foundation.org>
 <DJXILB94G82L.37YBL62YO9XBK@linux.dev>
 <4c969202-a8ed-41a8-9e9a-281a12f6dde3@kernel.org>
In-Reply-To: <4c969202-a8ed-41a8-9e9a-281a12f6dde3@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 37867C0004
X-Stat-Signature: c1bq5wppmrdsmyx4phfpu5e16ce3966x
X-HE-Tag: 1784022751-237209
X-HE-Meta: U2FsdGVkX1+CljwnvL19umJIJo8UlEb/Dh1MJX8BD/kmvl833L93vMJpW0gZ9VeWybYGkkcYdGg6htPXMd07k06fB96pB5QHKGYi4tJEUZqjBW3rX1z6Y6i5M+i65FrD9hWFYOny3MYMb/SCQd4pwhoktyIZFXApgjyWe+DRkMLL90K/wYa9hHmkYkGnyRDNJNet3U64vgP8d3SgYzX6RHas8pO4uBn/M/ZrnJ9NBxTNBoGuK8NtlBPE6cVDjF0op5avrBJbvyQQU9NwL+oRFA2UmnfMU08u7N3SQSZ8NdVPLbFbYwSgVN2nuDNadeCLKh+TqA3pA90G7SSeeGYu2OkHKJp8nOGP4248z9SQNtZvIpD3dQtVU8mkpVuAveBQk6NphYl8aMCBo6eLOB9NhI3NfjatE8PffFIStz9gMEwSuL9MQchzeZ41sOfZ/e68VK8F/XX1Rowc98n+jHtPG+t4OjGe6fSI0EQhVJ/LPYlY7hAbetVkevHvyBvJj2XecfjMsdJh16VNsFNdOUMFGNAS+Yz06bVzDpFAKcoB/HNAhiJ+NprwiwFZ+twer67Nj09s/UtbD8qfQUyF03+nMYUv73s9lvDUnsScfg32rk1tF4aegjTWBTdEpaJNJy6uyNYyttbEPxFh3celPegP3LbRSug9Md5veTXbZ2JH3vl2Gq/za7Ka7sc2Orsw0iWjPdETNqemeHZAQmdOKw9QyT8b65J1SApubVh3TUZAuA9xWgHmpO1tq+OVIaFr81obgztBuUiqBG4BUOyXzpxlwF6G3skVzeCoW0YyOz1YRR2w70rE3G83VV1f5hUicp1K3VFcDx9bZGCAolGw2aOhuiJCj8PE79OU7kKjo32qL68cxJlIAqoBWmNxB2YOJVmkoD5TbQ/g4Uoadka8CqpE1U7rXlUoObCN82GTSiaIG48sJkI+Uk0WhyT4xgUeYo3sWLjlhMC9Khhc5ktAfEt
 8SnVJLdi
 WFxoQmBMtDwdd6Fsnf1123wNpdU+EU4DOmr5eJPnkkGvgzILWIYneTUl/d0QCFyBApf0z8hEI0RAG/Nk7r3iGCGSCgOqVYfa1ot0BQ02L6DnU6Iic4wWg9ga32w/pDbVRm/9L5+HzHBAMcYpkJt/rBeA1xI+EG83ZSSGGvZhnA6HGZFP11h8YkfMsnTO2rYyNeqz1oi2aNrwNF7IpQ/68Ol1/YaVz/3ZBMP9noS2PCUk96wQV1GVcKSoZQub5xFDIw77d8oxo7nDlBk0A6J/4WHE9JbNotYsYj8YFQXZd6r6JTt+oGm+xrM3QWQsUlXizbnfUIiw9ilIRmH7hsnBO6nCNlHUBR6pHWVPHi8beo0Btib9asF2aVxOH3YbRZ1gJ8oanZnU1u6UvwwQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jul 13, 2026 at 4:15 PM UTC, Harry Yoo wrote:
>
>
> On 7/13/26 11:31 PM, Brendan Jackman wrote:
>> On Sat Jul 11, 2026 at 12:03 AM UTC, Andrew Morton wrote:
>>> On Fri, 10 Jul 2026 10:42:20 +0000 Brendan Jackman <jackmanb@google.com=
> wrote:
>>>
>>>> As noted in can_spin_trylock(), using this is unsafe in this context.
>>>> commit 620b46ed6ae17 ("mm/page_alloc: return NULL early from
>>>> alloc_frozen_pages_nolock() in NMI on UP") fixed this on the alloc sid=
e
>>>> but missed the free side.
>
> Ouch, do we allow alloc_pages() -> free_pages_nolock()?
> Didn't notice.

We don't explicitly disallow that but I'd say it's "forbidden by
default"...

But I think that's unrelated? It doesn't mean you can't use
free_pages_nolock() from NMI, right? (Would be weird to alloc from
another context and then free in NMI, but I don't think it's "forbidden
by default" in the way that using unmatched APIs is).

>>>> Reported-by: sashiko-bot@kernel.org
>>>> Link: https://sashiko.dev/#/patchset/20260703-alloc-trylock-v5-0-c87b7=
14e19d3@google.com
>>>> Cc: stable@vger.kernel.org
>>>> Fixes: d7242af86434 ("mm: Introduce alloc_frozen_pages_nolock()")
>>>
>>> Is this correct?  I'm not seeing anything in that commit which could
>>> have caused this?
>>=20
>> Oh yeah I guess it should be:
>>=20
>> Fixes: 8c57b687e8331 ("mm, bpf: Introduce free_pages_nolock()")
>>=20
>> This is confusing coz we have:
>>=20
>> A: commit d7242af86434 ("mm: Introduce alloc_frozen_pages_nolock()")
>> B: commit 8c57b687e8331 ("mm, bpf: Introduce free_pages_nolock()")
>> ...
>> X: commit 620b46ed6ae17 ("mm/page_alloc: return NULL early from alloc_fr=
ozen_pages_nolock() in NMI on UP")=20
>>=20
>> X is marked as Fixing A, but it was an incomplete fix. I just copy
>> pasted the Fixes tag. But actually I'm now changing the free path that
>> was only introduced in B.=20
>>=20
>>>> --- a/mm/page_alloc.c
>>>> +++ b/mm/page_alloc.c
>>>> @@ -2979,8 +2979,7 @@ static void __free_frozen_pages(struct page *pag=
e, unsigned int order,
>>>>  		migratetype =3D MIGRATE_MOVABLE;
>>>>  	}
>>>> =20
>>>> -	if (unlikely((fpi_flags & FPI_TRYLOCK) && IS_ENABLED(CONFIG_PREEMPT_=
RT)
>>>> -		     && (in_nmi() || in_hardirq()))) {
>>>> +	if (unlikely((fpi_flags & FPI_TRYLOCK) && !can_spin_trylock())) {
>>>>  		add_page_to_zone_llist(zone, page, order);
>>>>  		return;
>>>>  	}
>>>
>>> It would be nice to include a description of the userspace impact.  I'm
>>> suspecting that's "none known", but some speculation on what might
>>> happen to someone is appropriate.
>>=20
>> Ack. I think if you trigger this bug by accident it will probably crash
>> your machine in extremely confusing ways. If you can trigger it
>> deliberately from unpriv (depends on the rest of the host setup, e.g.
>> what tracing is being used) you can probably use it to get root/ring0.
>> Can mention this in the commit message.
>
> Just noting, it is quite niche because it requires UP, and tracing
> something that can be called in NMI on UP is even nicher.
>
>>> Also, Sashiko might have found yet more pre-existing issues:
>>> 	https://sashiko.dev/#/patchset/20260710-spin-trylock-followup-v1-0-aff=
b5fe5ed00@google.com
>>=20
>> There are 2 cases here:
>>=20
>> 1: !pcp_allowed_order() -> This is forbidden by alloc_order_allowed(),
>>    quite a bad miss from Sashiko IMO.
>
> Hmm but alloc_order_allowed() would return true for !pcp_allowed_order()
> when spinning is allowed, then pages can be freed via
> free_pages_nolock()?

As noted above I think that's forbidden. Now I think about it, I'll
include a patch to document this.

