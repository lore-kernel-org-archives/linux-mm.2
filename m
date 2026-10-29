Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB4B6606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 19:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h2m8gHYK
Received: by kanga.kvack.org (Postfix)
	id C6B6A6B00EF; Thu, 29 Oct 2026 15:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1BF76B05B2; Thu, 29 Oct 2026 15:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE4E36B05B3; Thu, 29 Oct 2026 15:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85C316B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:25:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 23705160434
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:25:02 +0000 (UTC)
X-FDA: 85376641644.16.4D701A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4520FC0009
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:25:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h2m8gHYK;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793301900;
	b=hb5BgSwv4CVIOqwigDYg2llhKiypxExgw/KrUthN6tb8PfZOo7oS/5vcFnURlwberuo0OZ
	SNgFLtue9sddqj/JkTsjIP7ziJmUu3nFOOtPCGiME1tu+Jr+k9xpJwSEjm7EaIvQpw98ZO
	6O7g8oy4bl9HKh5/79FLT3hP6p80IBI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h2m8gHYK;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793301900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vHvd/q4O+h986N5mN9exXE8IloUVYJcmVGFfgDmC9Y8=;
	b=g8wNntYk4/B4M3JnVftjYZkqCRqLIrvAWFK0BGYmYAqRTS0O43fU/PyagHtaPvd5M0aZQr
	7grW3XABL93sRlv0KKdSqaz2UajBSNLql0vRK/Cw8YxlRv5m4AgLV0JnPD4Boa+8hPse5M
	Qt1Ix7YWCi3XEmyK8XzNGfC1V+mEJXs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FB3340A11;
	Thu, 29 Oct 2026 19:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819681F01816;
	Thu, 29 Oct 2026 19:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793301899;
	bh=vHvd/q4O+h986N5mN9exXE8IloUVYJcmVGFfgDmC9Y8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=h2m8gHYKiowIWGROOIGIp2lgHFP799kn2vRajWijcS7Fh+fc7BMZU1zMShcDg9HTG
	 BfUh89iRO16QtmjcQSo0OlzshRrRS6mdNcVNOAxIUViFcgKe21b+qxwWBJcSGsHqoz
	 VEeNeJRVMbHLUGisCtyZPe/4fbCJjZUzlBePLM6WgJguoHTt5sCY168SJ5lmJCrPKc
	 05VZ7DuHlGYolvsBCbpYBiUfTe5Gup3enN/xMpqUH5GgftDE3ejr+Sv87B6DGXRF9c
	 kSzpiRKxYKfg1rgxL6Bwcb/rrttSBxByJG4kKkAfBWuSaxJhga7fO1vvuLksPwZF5r
	 Vq3miXW1MpUNg==
Message-ID: <2c84d8ad-d189-4127-9d1d-8cf0eb40c43c@kernel.org>
Date: Thu, 29 Oct 2026 20:24:52 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: use READ_ONCE() when cloning folio flags
 during split
To: Zi Yan <ziy@nvidia.com>, Barry Song <baohua@kernel.org>,
 Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ye Liu <liuye@kylinos.cn>
References: <20261029-data_race_huge_mem-v1-1-112e331291c1@linux.dev>
 <CAGsJ_4wndM+uFwhX+7wdkm2Q8AkgVcw_4wgpObfw0DAZ1w+sVQ@mail.gmail.com>
 <b5dccfe1-3209-471a-a34e-f77fffdee797@kernel.org>
 <DMHE8BEEER1H.2BIY52NXATPIA@nvidia.com>
 <d44e0aef-ac50-4048-952b-50a0307a41cb@kernel.org>
 <DMHKCEKNMA64.3B6O5X5918GWI@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DMHKCEKNMA64.3B6O5X5918GWI@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b7zz9cb7cbhr449zdstwfizmu3k34jhx
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4520FC0009
X-Rspam-User: 
X-HE-Tag: 1793301900-256241
X-HE-Meta: U2FsdGVkX1+81kbr59nte2rVfHScWJRDUKlP3XY9ueRGyhydl/TA/S26aJIMhQPoH4X6qFKUBy1VQBXgykNwtiuinS6QB7yhSNm7yIPn7aFGds0kOgiprWB0RzxaHUvy4TS1HVFSi/tSMGFQi4J+qSwduKIdVv3Jg/yCsVpAPp8SKimf9xPlWUZsGESnNzNb6k+WDpuljr0xC9Kwm6HO1l1+1evsSz5CPvOox54YwoPVXTeib4d2xS+87LBQpHVsnswKkmoon7v+9AK3KIcbxve2kAPmyh0nj3fl5Rg7HSM/Eb/z+9e56IVhjEepzzFK49qzlgZsU9xE30kQhQsA8wmzCkyY4TMzg2OzFO+064BtLBAMNLE73R4Bl6AuIF22Ip3kbfVQfhEtxPzybOwSl17Pw1DfhtTUpn8MWpxdB3vxhLco+jdS36wVb+MjscThJYBeF9KZDREVWPf4Km5L0OipQgG7dGE65bIkHHOaWUqaPEpSCO9dsHx3K/vPl707jk7QvVg105WrMXK9C3jsobz5GCA2QAdI59/p5jIxQ/OLnTdiO5rlSWKbcuig7noWygpt5khd5xgOcItnm7yXvpvEesV4FzKPPg4h1qEaYYQVl/M3859t6quIxUW9gfgasQa6BQ6AhEXoGT2BuNvVr4tAglfIeGPoCmgio8enMO8FpEfLfBPL8cxvdYI63vWx5WcdEeAM3dlcv3TzSq4c7EsTD+WHVdUYu2QlzdMvHyGKREbCl/c9rv856dTsN2MvfPOtsC2YIyfcWvrJ9/M+LTD9imAznDfKcCjv0XnO2VXQpx/qvhSX6F1V+++1Ur7ki4y/cnPp96ey2rwGV4/r6a42Y1qak63MH0071nEX4vUhDwpu9T3i/qA0m+ypddpjBj5cE+3v0isYs4+ddi6vnm2f7PGsy9uS7Fjpb1Sw4oaJ26Fh1IU1l8V7YqqN5QEb8hnt2QJIuxR6iSqbWuH
 RqfBA0G5
 biktP2EOWMT/3Gr1bkQdqzl606Vi5F2L5c5Tc2M+7+JesS3CB+5oCH3G7qSxUQlGP4rAr6gU3wgIF+ipunjLRPrNmznOalYb+6bXKafH5jbQCLP2aSoOfd5AccjIRXTNhGYPt3lZ0lfIPVbkHY+b4Bk2Ps5fzNy7UMZWQnvEaIcBPloxdA7F9MalEh7hNxKfzEj5jcgny+nNWwEpfs4XULg12Yzt747eMYUT4lHRavRAPggmyoFxJRtWPMn/02aXrXcIBIXBhJpHJZ83WKIyT8QJz8Rv/FURgeZeLB+ij4X4mIQUL4Tx66h9OEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 20:19, Zi Yan wrote:
> On Thu Oct 29, 2026 at 10:54 AM EDT, David Hildenbrand (Arm) wrote:
>> On 10/29/26 15:31, Zi Yan wrote:
>>>
>>> data_race() would work too.
>>>
>>>
>>> The PG_waiters on the original folio/the original head page is not lost,
>>
>> Ah, so it's not on arbitrary tail pages, just the old head.
>>
>>> but there is a chance PG_waiters is lost in the new head, because
>>> prep_compound_page() uses __SetPageHead() and can ignore the atomic set
>>> of PG_waiters.
>>
>> Fun.
>> ...>
>>> Solutions can be:
>>>
>>> 1. Use atomic SetPageHead() in prep_compound_page().
>>
>> That sounds like the right thing to do?
> 
> Yes, simpler, but the atomic op can be costly at compound page init
> time. My plan is to add prep_compound_page_atomic() for
> __split_folio_to_order() and the atomic version SetPageHead().

Makes perfect sense.

-- 
Cheers,

David

