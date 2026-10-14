Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2A29CC6B20
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 04:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D7526B0088; Wed, 14 Oct 2026 00:25:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6870D6B008A; Wed, 14 Oct 2026 00:25:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59D1C6B008C; Wed, 14 Oct 2026 00:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 39DBE6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 00:25:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9EF1E160437
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:24:59 +0000 (UTC)
X-FDA: 85319941518.21.46FA539
Received: from mta1.migadu.com (out-76.mta1.migadu.com [95.215.58.76])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7450A18000A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:24:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gd0b7toG;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.76 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791951897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/4RCAHmxfZKog+Rqrr2dhf+m/n4L+JGt37JmLoY3fs=;
	b=qt76f9Ild4HjZVL0uH4+PooUMSgnZfX4wuCXPEcF6v/j4fQfEmvRFBgOkfk9OwL+sloJ6H
	ABZ7CsXc31dZ9/TsFzud3WXzSJN7vpPQACoCuLn86lhcjTK9uyclg4dGfRp4yHErGsRICq
	91PUtnqE6RvErKBymOAe/nRwRvvTWlw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gd0b7toG;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.76 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791951897;
	b=0EMv0AFFpQL4Eu2pYGIcPULE0iAiAE1RpUXVTlkuIhYfYlVAcj8wJeYXMX+4Kf3VLGz19F
	hhrxWBazDaLqtyP5QWkqVlElOqz9dCEKjWB9EC2G0msCHp6sWUDqRg7DV1E9DdV176yw1w
	d7TIWVV3cBx8eW8oCJRk48rwNT0ZkDQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tOKfQbBfrehty/qW3pINrljOFcxIODGYHAtE2STWOrY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791951895; v=1; x=1792556695;
 b=gd0b7toGmMGQDvpmBBvyyF3R02lD9xSMO1zWSRXnAw8D/oooqnqMObDHfg1IX5NEjYH/NXYN
 qsZYwebFpj2UQBi/rq86Egs3R9oaLkH8uquYbANSiOxaploED0AS76bAvyGzNGBObjZK9Pv5le7
 N3DdpIyQIeXZ70vIDXn6rQwU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 967b8fc28b66cba3;
	Wed, 14 Oct 2026 04:24:55 +0000
X-Mizu-Trace-ID: 967b8fc28b66cba3
X-Migadu-Flow: FLOW_OUT
Message-ID: <75a46520-0771-4a50-ba77-ba815dfb6bac@linux.dev>
Date: Wed, 14 Oct 2026 12:24:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm: unqueue deferred split folios outside the lruvec
 lock
To: Barry Song <baohua@kernel.org>, joannelkoong@gmail.com
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hannes@cmpxchg.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 usama.arif@linux.dev, hughd@google.com
References: <20261013221307.850803-1-joannelkoong@gmail.com>
 <20261014030737.2102-1-lance.yang@linux.dev>
 <CAGsJ_4wxKQK=caM6a_AqJArGyJdBgq_=i=gSNjiVePkGBZHnpg@mail.gmail.com>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <CAGsJ_4wxKQK=caM6a_AqJArGyJdBgq_=i=gSNjiVePkGBZHnpg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7450A18000A
X-Rspam-User: 
X-Stat-Signature: 1oi43x5u3ipadm1tioqbxx9idtxp4zag
X-HE-Tag: 1791951897-555415
X-HE-Meta: U2FsdGVkX19u02wrIEytAcFi0A1nxpD5068OrjMbJAWJCzu70pF9K4C2iGBa7Heykd45c8j0czPGX1rJj3BQgFTPgzTAjqIV795sOsvYafJSYydbgqJDoephD986lFLc7N0PeIC+BdTP4248aE7W952qo1wmwSlfHQUbFq2pVHq/LKNjH67zE4fLXfkvz0F+QxoB0CjWRd0KjdLOmkq7kl8EGHe20Z+fIMUZSVvvLsQTLjtfYFmnljwbKpHLBPj+g6EiJlCbvPWYP0K3W2a/VAAo5jIwYI5XRj4Y/v7iU5HTTQydJ67KYQ2njLaKaXPvQUm52l9xf3V1DuGRPBbMfr0Ql0X8enaGKnAIqpq/yBhZPupAOSMWAE5EWsMIosCkt2z9xJpeWlp5rJu1Q/xvPj8dN5z+oWrngrhZ/CRCXDUXeAAJ+YNGf1x+irOlP4AcikYXWmAWVO8OM+S2fsjlhKwxyCRZCtS0jZCcS/O7Eww5qIMEw+qlYs0TPd2FcJaLF3nd0d/YwXz+EAcvCA/iKfx0c8ZOLNCAD5ML/PWSvJ0IrkUwI0aRClaXt1u+d+yfnSw7+Iz5lWVqml/8qFHtto8xjGvh+I4p2rcUa+InYwhz19XJn3Zduty2gOanigVERddCaVqna8WR+MeSjPZ4fZzjk1nfsSEWnCGiSm/ycFFPTO40ixUMBaPe2mqxmTOekIgrkG5U2JGHOdGO+zkG67cOEVN6a05F9xJxeolFaNMOA7BnIYpUUvZmGUsaPWQ54nBuDEgfI2RXnIUGyMNUcWR63cby/3K1LlCMvHiaWTRCtS1XS9JgbXlBFU3rR0d34tRsWJZbnKjjsb3dXN/OYkrjYS3z6oQTo50BgZxeD5CTMoWjqm660MhHObfxsj+q60vQ08nfckrJ4xF3JvWnrLyI4YEcABuwHpiJ0Ob8dmtFe2oIwYA3uZutDiLcaGp/PM1hL53A5b21f/hVFOS
 dWZlX5YO
 HyQiYI5yIfubasxiK1/XE6tuX2OerJr/z5gMNhu7T3CVurKByd9T53WhZYcE6WBUSa6kbuM7fFwmo4/9MWBUi585eJJ8lPlua6UcpJ2BIgRrP3+MJ70FHaB1wzI8MMHR+e+csJfdLqTpamP6MHgl1a+Z9pvjcfc5m95YDuOtYMyJuL29ggzBXMMYbn1vHZogCfiNwVslBzUp5RkOKbU5lx5V27O75eFaMZH9Clg52Sm4kSWH3IKYmVYwMIrBy6UFYzjI5TpPv28kJp53pELctLDfAnu71GBd7L5o9BMqYJO5xpWbyS+De6pTwydYGOLLfYipYAcvBxjYb0LDkNvY8MWyTQfUdybGsEfe/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/14 11:13, Barry Song wrote:
> On Wed, Oct 14, 2026 at 11:07 AM Lance Yang <lance.yang@linux.dev> wrote:
>>
>>
>> On Tue, Oct 13, 2026 at 03:13:07PM -0700, Joanne Koong wrote:
>>> move_folios_to_lru(), folio_batch_move_lru() and folios_put_refs() call
>>> folio_unqueue_deferred_split() on folios where the refcount has dropped
>>> to zero. In these paths, folio_unqueue_deferred_split() is called with
>>> the lruvec lock often held (move_folios_to_lru() always holds it and
>>> folio_batch_move_lru()/folios_put_refs() usually hold it for every folio
>>> in the batch except the first). However, it's not needed to hold the
>>> lruvec lock.
>>>
>>> The lruvec lock protects folio->lru and the reclaim LRU lists whereas
>>> the deferred split queue lives on folio->_deferred_list in
>>> deferred_split_lru. The deferred_split_lru is a list_lru with its own
>>> per-memcg per-node lock.
>>>
>>> There are already other existing callers that call
>>> folio_unqueue_deferred_split() without holding the lruvec lock (eg
>>> __folio_put(), shrink_folio_list(), __folio_migrate_mapping(), ...).
>>>
>>> Add folio_batch_unqueue_deferred_split() and use it in
>>> move_folios_to_lru(), folio_batch_move_lru(), and folios_put_refs() to
>>> unqueue each batch of zero-refcount folios from the deferred split list
>>> after the lruvec lock is released and before
>>> mem_cgroup_uncharge_folios(). This helps shorten the lruvec lock's
>>> critical sections, which run with IRQs disabled and are highly
>>> contended.
>>
>> Nice work! Thanks!
>>
>> BTW, have you seen measurable overhead from unqueueing deferred split
>> folios under the lruvec lock?
>>
>> Any before/after numbers for this change, including the cost of the extra
>> pass over the batch?
> 
> I recall Joanne mentioning some data on this in the link below. Is that right?
> 
> https://lore.kernel.org/linux-mm/CAJnrk1a2PpUGTsCgS7jct2KET4K2zAL+_h+te8G1MaU9bXs99w@mail.gmail.com/

Thanks, Barry! Yes, those numbers answer my question about the
observed overhead :)

Joanne, have you rerun that benchmark with this patch? I'd be
interested in the before/after runtime and lruvec lock wait.

Cheers, Lance

