Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6192C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 14:06:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C93406B0099; Tue,  8 Sep 2026 10:06:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C43BF6B009B; Tue,  8 Sep 2026 10:06:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B33656B009D; Tue,  8 Sep 2026 10:06:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 991516B0099
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:06:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3F00A80616
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:06:41 +0000 (UTC)
X-FDA: 85190770602.14.BA6D18D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5AB1B4001B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:06:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=afMC32TD;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788876399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f7ftTctWhPE4n03ECx8E4+9NjKLH+G10qtgVnkb8zSA=;
	b=v0WdFovEtH4D177bPSLFCFWz9YsuKXCdkB0T1tCuP32I3tOXjQKzoDE5S8/a4IZxHVK2EE
	Gg+PnYtIK6sYVdHjgJDnftkHIo/oqyX6ppRGWevBq5eOlb7Wpgbdtn5Yn/ZEsy89jijj4A
	C9+WcKhGOV8uV0dAN3TdcY2Jg2lwJmA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788876399;
	b=oWx4lSMJlXQsJa6Mmqap0t+Q4tLqbKQAh8agN1Isr927rnCjNGbCUVH8lLsnszpOkqI4Fg
	OIekJ5sZipJBA5KI314lZI/x8b3DxgXO8MWK4TaZGwVzaKFMaiHPHXVwyqs8PHMzB9FMdA
	ikON64hR5SrKyeqg506eiT04e4V+1QU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=afMC32TD;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 604AC42E16;
	Tue,  8 Sep 2026 14:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12261F00A3D;
	Tue,  8 Sep 2026 14:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788876398;
	bh=f7ftTctWhPE4n03ECx8E4+9NjKLH+G10qtgVnkb8zSA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=afMC32TDNkE67v7lovIBvQfJ4zhHUyUuV+5pkjYgCZC7n9fh/o5Dns9UOJjhpJ1yk
	 1B+HkuSVULxNeZpQWxTuOz/G/ES1fp30nq7vG7JGMxcpnS9nHRq01l17+NNc1l7jSa
	 Mkc9ECVeJzOPjX3DZvCW0rR+z+aHcb9wUbZG55vO3A6hg5MAgFn3zvEXTY8BmTrbwy
	 f3Z0NO2wBygyC0LFXz4at8Gbk7MZ/o0HjjUR6/w7DXTpvEdIu6ki5MqjU3l5BpMXUp
	 uzUwOfKYYOpZfWPLnPl1qzjGntiDe54xCzCOnR/8RbGCq1979ic0H0ioXSRR59ZCyE
	 QawcocYU62log==
Message-ID: <f41abfcf-82dc-4fc6-8dc0-c4d0ba6d8405@kernel.org>
Date: Tue, 8 Sep 2026 16:06:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, usama.arif@linux.dev, alex@ghiti.fr, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
References: <20260707201735.4113107-1-joannelkoong@gmail.com>
 <20260707201735.4113107-3-joannelkoong@gmail.com>
 <584098de-dd48-4004-8e7e-3d826e60c860@kernel.org>
 <CAJnrk1Zc1cZa5edmb6Z18nO3xfLBww-7wobxkOe2OJmWE9qzpA@mail.gmail.com>
 <7da62e60-6ce2-411b-acaf-f9f77ef34752@kernel.org>
 <amoWjOnPayHVQU9v@cmpxchg.org>
 <b93cde83-0ce3-4db2-8e53-29864027d655@kernel.org>
 <amtv0YRbSrN6iUEo@cmpxchg.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <amtv0YRbSrN6iUEo@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5AB1B4001B
X-Stat-Signature: bbn5j15puixotpo3sfhibw16kqe7n4in
X-Rspam-User: 
X-HE-Tag: 1788876399-592575
X-HE-Meta: U2FsdGVkX1+culck9hRJgrMAOSbbtmn3F1xgm6qGJULmVMARi3IJZLUyezky5/jpBxeSEUtjWufQnW1ipE0oUsUcq/Z3ldFk4dXIQRXS2TIqgWUYip81PAkcVJwqHDF7tuvCDUW9j5mvMgL9wwLMShGaPhuzVdQVsnCcrk6eA17YtlhJWoLHGGAdT8nyQ0UiYnRLk87PlcYckQ5W50rMPQx7o6niYITQ81UkUmwM/RgqOuzMkwjXWDzJY69BDpWhdELGIdV+1gpu6tIakRqfx5FOm/+aMDNBHNw/7CXGfbMiHMw2haVcB/GibkAd2ilE5cApxA4IAeq8dL9MdOVKkGcV7kzGipIXe6Rfi00mL5Q4CARrj57r0x11W1nBIOq5rgHPJDfPRKFe9ve91xQg2HKhLlFnpaed6uSm/3IUg51VcEQeaLV95HY87Qvp3VC8ColjFnr4O56jGZ8B1agJ0T1NGKnAio2DNQkEhy5iv1TdSx5aMlblUWpLDFTA6SHfxqmmpqxyOuaOu4mibo6/79e2eISjiTpGC/ltib40UN/hSQBj2z2DrnEjGk2WA436G4KudvlvPbJD7iW32ZC61lN2FOnWDChzOp8ugtoLTAV3C1lzg82vxvH8AnYADVFXoelhyA0Eahu/dttXIUhSE46LMjdpPMS3POHStwjQbj7+8sWeOM6j2IdYv/KIETFTjL353cDG4TglCHTe2Zk6FwsU0aXmm0WTxawSxXrv4Jlxq7pY2yuiJff+VmznHePQalsPkDf2cS9LTItX+fHpQkYQpSUQxmJlrCV/z1+xruCl1+TVZ4DL33Yx3xtCwMBwaoac1H1c+I9m+cW8/Ctt5d+cWMYD3qEkEhHk8ojYf/w+nZXfp8rKSVBlRGZ/4vL/t6+vk31W91DKe+sTPO6qYZ9ol+ppEaYtRo9WTeVjpWqHF9G9Eg246OuJDF7RDT4dpiyapzxMjaH9lGJm9sZ
 cvwjxX3N
 rNq22owkZKEScN2543xgimUB/TjatMyj1E2KHFwlMGLsFkXXm2VSK7TS3EJxa6Le6vODBJ05DS0TZB/hjR9KCNE3Ei6CTdwK+T+IsYvjmGIC24oqQVgpMAHrvUrYf7jpyhcaP/mJlT858Eiqw9dSQ16N2sVAuHpS21hiBGYlhTDjsxiX0IiGHF0HfKjPs92rv4WfYW7g+jaSbylOvQnKzeyfe+wXgYe5tHaLUD+XwBqfB4tTRReiT6wDI0bOs+Eaz1whtOXt215MEiUA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry for only finding now the time to reply in more detail.

Just to restate: I'm fine with an approach that defaults to not adding folios to
deferred split queue, when they are never going to be deferred-split (according
to the system config) :)

>> I don't quite understand the "a single fault", can you elaborate?
> 
> Let's say you have a 1TB host with 800G anon populated.
> 
> The oldest folios on the list might be THP. The newest ones might
> be. You could have a mix of basepages and THPs. The ordering
> constantly changes as the folios are aged, rotated, reclaimed.

Yeah. Some of them partially mapped, some of them not partially mapped. Some of
them already-scanned for 0s, others not already scanned for 0s.

> 
> How can it find a handful of unscanned THPs in an ocean of folios?
> Even if you mark the folio state, that's hundreds of millions of
> entries whose state you have to check in the worst case?

My thinking was that spending some extra time scanning in the deferred
shrinker might be tolerable. The real problem is "some extra time" might be
unbounded indeed.

> 
> The lru lock is one of the most congested MM locks on large
> machines. *Maybe* you can do it locklessly.

Yes, that's what I had in mind.

> 
> Maybe you can add thresholds where you don't scan if there aren't
> "that many" new THPs just yet. That means magic numbers and reduced
> predictability.
> 
> Maybe you can be clever and scan from the head of the inactive list
> where (most) new folios start. You still need to skip over basepages
> that faulted after. Skip over the referenced pages that have been
> rotated around concurrently. That could mitigate some common cases,
> but not the worst case.

Ack

> 
> The search pool stays enormous for the entire runtime of the
> workload. It never gets better, never converges. It continues to
> include every other irrelevant anon page, and every THP that you've
> previously scanned already. A single new THP fault and the search
> problem starts over.
> 
> I just don't see how that's algorithmically sound.

I was also wondering whether the LRU could help with that (internal separate
lists etc.), but I wasn't quickly able to come up with the obvious solution that
would just work :)

> 
>>> So I think reusing the anon LRU is flawed. It's fundamentally
>>> different needles in fundamentally different haystacks.
>>>
>>> If we can agree on that, then the lock contention problem has a
>>> different scope as well: it's a simple optimization issue, not a
>>> fundamental data structure arrangement issue.
>>
>> I don't agree yet :) But maybe I am missing something important.
>>
>> Note that the "simple optimization issue" is not so simple once you
>> realize what kind of a pain the batched LRU already creates us when it
>> comes to predicting the number of expected folio references.
>>
>> It's a pain I don't want to extend to other areas.
> 
> Since we already need to do it for the LRU pages anyway, isn't it a "+
> in_deferred_cache(folio) extension to existing refcount checks?

You mean, the refcount pain that Hugh is trying to finally get rid of for the
LRU cache? :)

> 
> I don't want to sound dismissive at all. It's a problem. However,
> 
> - it seems way more tractable than the shared list,
> - nobody has produced hard data to show that either is justified.
> 

At least for large folios we have a more reliable way to detect that a deferred
freeing cache would hold a reference (e.g., spare page flag in page[1]), so it
might be easier to detect expected folio references. Not sure about concurrent
races when removing them from the cache.

-- 
Cheers,

David

