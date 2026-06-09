Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68BA7CD8C92
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 12:52:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6E006B008A; Tue,  9 Jun 2026 08:52:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C455B6B008C; Tue,  9 Jun 2026 08:52:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5B6C6B0092; Tue,  9 Jun 2026 08:52:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A720B6B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:52:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 408BF8F5AC
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:52:25 +0000 (UTC)
X-FDA: 84860362650.19.EE54984
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 67B8620011
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:52:23 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gMsLiJ/k";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781009543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6RVksM1q/xCzaj5QI2KqOkAZj28JqLKLzQFq6yryIo4=;
	b=YTBM3BBNJ0owUHSI6xEwqfxQfCLTAUOcL8K5AwWRHZwclNFRkJRLlUyahIpfInvrGP84BU
	fzyU3WRd8wlwBUMvMJmiR3s1WKmPxlyfsPstAezL1PenHR9fZ1/i3drz6ktzwj/611O4dK
	AsunQjNTE0bJpO3bcs9IJrdjv28luiU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gMsLiJ/k";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781009543;
	b=J71uBAFG41B+SRMiaPmRBUqKqSFLS0W5tF/GLPQipFRtxAN/ZwYQoVNFcYyvl40QqZw0d3
	RScXEbEmaVy2tr9wEU+0uJF3jDBdIpf6Bn0pE8FHaw5Y15a5M5BvG2C1XJxKEhrq9JA6vS
	lTtX4fSlOJms0u8+cZ5SwEh7wQ39eu4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D5F9433B3;
	Tue,  9 Jun 2026 12:52:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E1A1F00893;
	Tue,  9 Jun 2026 12:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781009542;
	bh=6RVksM1q/xCzaj5QI2KqOkAZj28JqLKLzQFq6yryIo4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gMsLiJ/kd4lFpp0rUts/FQ32exqVF+EjEbMhMwmzetICiVvEWYclp910lfp2WZR2a
	 wpZJxiFq94Qxa6otRthSQVe/XirLEXN+bi2tek4xxWokxIhvt7yN9SiPYoWCv21pOL
	 N9eG3lcDurR5E+WXDoao2/Ca6NFb1IcLADYTFgSr1s6DTJcLIVSjgmCm50InLQ6bMI
	 WPgTGrpIPE92wCnJb0frum0xr3FCUiIF9EsjNJxfNji9rB273wouFm1GLaY2YNcbaL
	 ZJ7HIpzG4xrt6TbjAhh73IdJUmhiwnYwPGk5nLG8ABMdHAfJyjtIlSsEk74UBj/KIg
	 qxS8qP2qe616Q==
Message-ID: <e8f0e69f-c846-423c-9ee7-cbc62675697f@kernel.org>
Date: Tue, 9 Jun 2026 14:52:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/8] mm/slab: enable runtime sheaves tuning
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <liam@infradead.org>
References: <20260516-sheaves-tuning-v1-0-221aa3e1d829@kernel.org>
 <agr8Nzr8rnDBTuVX@pedro-suse>
 <682945f5-2d00-4bc8-8e23-59189b4472c6@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <682945f5-2d00-4bc8-8e23-59189b4472c6@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 67B8620011
X-Rspam-User: 
X-Stat-Signature: 1g5f7c6nf1gnpbceu6cy1cbj7x8mgc3p
X-Rspamd-Server: rspam09
X-HE-Tag: 1781009543-46882
X-HE-Meta: U2FsdGVkX18NQwkG1mist1W1kjYA0qPdcmfGMpcO9O0japO81YywRJH61fy7cGL4FpHDV1g6fmSUGas9MY9eXL4qh6rKkD2eGs5yV3/bITtkptshNxIV2JXe8N+M0KtJUZc0eLXPePx6NppedTii+5oFc3vMapGFaMp+Frn8EL2RdfeO2zionwkL/TN3O//+/TR6XJycTSdtUAOqPxggNYH98w7smmHYZCPCvclxYom9eO0S59913KgYiKWFrbJPOxzoGx0XyLxObuLlStAf5zLocy85JDLpax6Lu4nsYPE2sdL3Zz5orIIawvQhwlv1GZ+YSDykjj8EMUnxJK+grp1ysJWCilSGB1RJ0sXs3cFdSozKDZIC6a5jIr0AO4/uL3179icXP+0H21r5Wi9V+tNXD7+Rps2UqCMWe2w+mxwOIDanBpwniEiPEgz78pypV/+0QXUEjopfcMdNqMrTHRMePdWB4flonlAg/k420ykUBYqDr5nvkvuAgX/jJJBrpxHJmI0n7ZRmMTO2uW+39/hYRI9c3j5BLtN2NDelEMrbm8zT6eyVJtucPtRnGuxwWR1RpaP2Q3PsjkMeKSLnp0tdRX6xuhh2YGgM/g5hq/Vj7sYZdOncJTWg2C1BaS826tT3pDMQdc6uRklcvuKOKxb5YfYiLcOEPzYkUSSHzaG7Oh60BslXw3zlzxJn92sQ0gGCycyjt3dU5JP/aopmryf/90Sm+moT1iTdgdtjI7vamY4AFxd6omzZ9QgWARrJUUCTvZZWfiyOvlK1dtBU8XiYjbOMmmMlWrb1oV2FsGOn8cO2iheaqNFwJ7/aGFvqz2rPcgSd3X/TkOMrMoDFyrwFNYl+xUpRgLBqK2Wq68sZpC5BEwlfeZFmVVvl2rpNhRLSYybREV7QC1/iR57tvq1EIO+Mz+wyZudgFWM2n+h749nFYRENbv18qoKEARepOzzEWWG8o67KsGjodol
 Ep4LfdUg
 BZEEO5tygEnC8XJyQcSYjcKm5ohE0p3m2LX6rplM6cbBlk0EE7nemDsXc+8RyzuGYMdvlCJ+Ehpqw+pXXCvJESzKCd6CcocUFsJu0PHqSQKHq1abR7K4zaj8y5g1hJ1qmd/8t/0D3muPNxL2MpsRdSScUl/wNyHmU6klxslYxxX9zZHtjMF1PZYS/pXnpjlroCbnOWdE139ydoib+J6REkbFXAe9ZUKH+ikHbm+aCOU78CQV89FRo9Ke9kcE2yWQSxpqz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/20/26 06:35, Harry Yoo wrote:
> 
>>> ==========
>>>
>>> 1. Allocations and frees can happen concurrently at any point between
>>>     these steps, and we cannot introduce heavyweight synchronization
>>>     mechanisms on the fastpath.
>>>
>>> 2. Currently, cache_has_sheaves() checks whether a cache has sheaves.
>>>     This works now because sheaves cannot be enabled or disabled once
>>>     the cache is created.
>>>
>>>     The question "Does this cache has sheaves?" should be split into
>>>     "Does this cache support sheaves?" and "Does this CPU actually has
>>>      sheaves enabled right now?".
>>>
>>> 3. Once the sheaf capacity update is complete, no sheaf with stale
>>>     capacity must remain.
>> 
>> Why? I don't see a huge problem with having multiple sheaves with different
>> capacities, as long as you adequately, opportunistically kill the sheaves
>> if they don't have the desired size (say, once a sheaf is fully empty).
> 
> Haha, you got me.
> 
> Right, enforcing a single capacity at any given point introduced so much 
> complexity that I started wondering myself about whether this is really 
> essential.
> 
> My main concern was that the performance characteristics would become 
> too unpredictable, but actually, users can avoid that by disabling 
> sheaves, shrinking it, and re-enabling it. So that's not an enough 
> justification.

My concern would have been that we would need to track capacity per sheaf if
we allowed sheaves with different capacities to coexist.
But patch 3 here already does that, so it seems it's necessary anyway...

> When I first started, I was quite cautious and obsessed with the 
> invariant because many parts of the current implementation assume "a 
> kmem_cache has only a single capacity, and it doesn't change", but 
> that's also addressed by this patchset. So that's not a big issue either.
> 
> I agree that it is worth trying to allow sheaves of different capacities 
> and hopefully that would be less intrusive. Let's see.
> 
> Thank you, Pedro.
> 


