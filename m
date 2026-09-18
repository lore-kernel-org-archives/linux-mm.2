Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A57FDC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 12:55:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B71ED6B0095; Fri, 18 Sep 2026 08:54:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22B46B0096; Fri, 18 Sep 2026 08:54:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EBBD6B0098; Fri, 18 Sep 2026 08:54:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D0546B0095
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:54:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19A42A067A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:54:59 +0000 (UTC)
X-FDA: 85226877918.23.F4BB3F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 636671A0003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:54:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VZQJ928K;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789736097;
	b=6Rqnu9gmsP1bK1sqPu1++xb7XOndEOM6XATxQZZ/RAipd/hWLpwQluGorMbvKHB6yNPsZi
	d/0KrvDsJuveDyOfdiSgiKwn3S+P/vaaDdfIc7NL81HWYbZOjehWvFe90AViILSh5ygDE0
	g1PhKaa7ymnyUFUQxTQFmnqHCOPZmv8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VZQJ928K;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789736097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r0GY3Oko0Gbyya67DBjVH1KdCICd4o8CJaN93+aNccg=;
	b=w89SjiWuV9AR81EiaUUXjHnKuZVeA26XIkYcA9z/lQVcurqwuzW3FzwzOYeAwFsB6CNblK
	IRqH/rnn9X7ynHNqOk26XVK9e6HD+SilAn8TFYcllmu51CHD2rNO73HDv+3NNGNy5PJuHb
	omEMNHP9nlPcEkFNSJD9xyVQHJY/sTw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DDCDD601EF;
	Fri, 18 Sep 2026 12:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C476D1F000FF;
	Fri, 18 Sep 2026 12:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789736096;
	bh=r0GY3Oko0Gbyya67DBjVH1KdCICd4o8CJaN93+aNccg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VZQJ928KoPiRfzqt8AG23Cmz8U28jicRXzuRF8TTlgkZ51YY0MvOnrtb4HBCVE9lg
	 FMLU9ANEhkqUXnsLk7tfpYXFdukAvjd41OHOTRt9NiPlRl/OaKVN5qT3mpLejX9cmE
	 b5f2PY32Vjc7SpYpQD/iG6YY3kpQk1OXTRPs5ow7vRATgGqh3QZEvY1u7GtvYbsQN8
	 Du1wtbDVw/bJ6Cs9GG4IbmNetnSmlfAeFu5JXntvlmyPRzvN6OEwVLh6i+bML7olFL
	 YeZOjiehgW9qg19m+UL1UF00iWAULIRL85ZS2/hkIbbBa5xEb76gl6P5MlUGDc/Wfs
	 5U1nSsRvgs1Zw==
Message-ID: <2c9f5d85-3396-4246-8179-3358a00ad223@kernel.org>
Date: Fri, 18 Sep 2026 14:54:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm: allow shared folios to be promoted to a fast
 tier
To: Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, baolin.wang@linux.alibaba.com, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 jannh@google.com, pfalcato@suse.de, osalvador@suse.de, hannes@cmpxchg.org,
 raghavendra.kt@amd.com, stable@vger.kernel.org
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260911001826.2109390-3-gourry@gourry.net>
 <DLHS4KFPQ86I.1J4LN3352RI71@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DLHS4KFPQ86I.1J4LN3352RI71@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 636671A0003
X-Rspam-User: 
X-Stat-Signature: hjr5w5ft7yoje36bytpwon4acsirqbon
X-HE-Tag: 1789736097-157244
X-HE-Meta: U2FsdGVkX19mzwgYe4mIt3GuzRqoY9BoZL++4vTEwChFfneMZXJRa6nK6OQFtUzzP8QmdUNxdgqd355ZEr4OAARqKBgNbjoR9ygwyXPcSrIAvMmrzcN3yifVPql63+ugj6p6Wv6komIr4S0k2hzhb2Vn/vVde4gsm+7KebFvEhkt+TQ0nuey5wN3opHYMr760onZCsSJ5B4A2/bgl3fH/CcbM24AdAel0W3PvQUUiSS23QdqLZ13U794YcBf9EWWG3QffQXlF3sZenv+Q6fYdi6YmoleWhoOKyvYeFbQLOnYd9j5KnnBA7SkYJta1jlzInsnI8xGTRDGqfwDc3rcLmoq6xafuIo30lOERISg6fNpuv4T1qcRzwtPDAiP8SnPGKbgzVcxx7hGgRz/VzbG6+Y2EHxQVBwyU4PqFFjJ3gx0SN0nx+s6AU+2lkDhbIrgFPBI6qFc5dkVoqk4dVnkEXRd7GKDhkYHsMT90iSonLQr7wOpWD9q7c6jijfP8Vnd4o5ojDZ1ASB0WKfhfbCw0dvacdXAbQn1g4S18zGwH8q9qI0gwTGBKiVF6/SIq0zavspRhWEmD55RR7EMgLm5D70bZK4p+nuQ4tF54yY+Cf9TtiBwfwLyiGQ4X3EbNbEyutcb7SP9wrRheGXyE3oXGuSTwVdDCt9+4QMMK2z7V6xMweHF41l9uYDy9G/ZMPlw0t34rNZ75u5WxCcboP/x3yFe+tDVI2ODUeqKVpiOmK4GEVnaRDou/Tpb6NUx/ourGzREIc3BMVDGEizECIWJIFrNL/xiFN1lqsBU6snpbG/ibFFKoBttU3BGjDotZZQ7/ukQRZ1uN4nSSYxwyH+W99sLAfeWbl2VlYFFU69HLfB12UX5xG+xDOrguTjbuaMpxlgLmgpMtNl5CoZ1npuAfesjZAgKqxCG7mOLpPPua5S19E6sMJDyv4GC6o1vh/x2wbXNfxI4LAADei770s0
 QEICkDOO
 O+Zxz0oh5H6C4fWGb46bMdBX5TElm1g2F3n7HkG4aDQncYQMf5/xC7HZgUquJzlG+BXhUFzKh2agoOcQZDhK7DX2nO7sWMJGIJFwZH+4Tm4Boe3uqeWP0pnGwDOGPxEw2fAeka67uSRFXiKY/uoCHGM7xRNgJceOANAb8BvGWtXIQDruagK1ks3PD8vTnCRNynHOvTo9o8Qy/F++r1rpoI+xfqj6ZBGeEXDtSS2esoj22aeD/a/8+xmQosGSd/DZBddSbXKebDrVqgYrXI9r4KARWU5qd36OIFE0ALgqE2W/V6A3A6BQ3iKXh128w71A0D/UndNzFwEB+BWlx8P15oDAXsuRonKlYysrY+kdgG2kbGobMkL52Wz3P3b+0uNtUdwNvbk1oFz6FqjJnQKThHeZ7y2fTpR+vuRWG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 19:49, Zi Yan wrote:
> On Thu Sep 10, 2026 at 8:18 PM EDT, Gregory Price wrote:
>> From: "Gregory Price (Meta)" <gourry@gourry.net>
>>
>> NUMA balancing rejects shared copy-on-write folios and executable
>> file folios mapped by multiple processes to avoid placement bouncing.
>> These checks also block promotion from slow memory.
>>
>> Allow such folios to participate when moving from a slow tier to a fast
>> tier. Keep the existing restrictions for ordinary placement.
>>
>> Fixes: c574bbe91703 ("NUMA balancing: optimize page placement for memory tiering system")
>> Cc: stable@vger.kernel.org
>> Assisted-by: LLM
>> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
>> ---
>>  mm/mempolicy.c | 8 ++++++--
>>  mm/migrate.c   | 6 ++++--
>>  2 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
>> index a082ccfa09ec..19b599bc2dd1 100644
>> --- a/mm/mempolicy.c
>> +++ b/mm/mempolicy.c
>> @@ -863,8 +863,12 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
>>  	if (!folio || folio_is_zone_device(folio) || folio_test_ksm(folio))
>>  		return false;
>>  
>> -	/* Also skip shared copy-on-write folios */
>> -	if (vma_is_cow_mapping(vma) && folio_maybe_mapped_shared(folio))
>> +	/*
>> +	 * Shared copy-on-write folios are poor NUMA placement candidates, but
>> +	 * a hot folio on a slow tier still needs a hint fault for promotion.
>> +	 */
>> +	if (vma_is_cow_mapping(vma) && folio_maybe_mapped_shared(folio) &&
>> +	    !folio_use_access_time(folio))
>>  		return false;
>>  
>>  	/* Folios are pinned and can't be migrated */
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index a369d0c95c38..afd9c97d2389 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -2697,12 +2697,14 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
>>  		/*
>>  		 * Do not migrate file folios that are mapped in multiple
>>  		 * processes with execute permissions as they are probably
>> -		 * shared libraries.
>> +		 * shared libraries, unless this is a promotion from a slow tier.
>>  		 *
>>  		 * See folio_maybe_mapped_shared() on possible imprecision
>>  		 * when we cannot easily detect if a folio is shared.
>>  		 */
>> -		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
>> +		if ((vma->vm_flags & VM_EXEC) &&
>> +		    folio_maybe_mapped_shared(folio) &&
>> +		    (!folio_use_access_time(folio) || !node_is_toptier(node)))
>>  			return -EACCES;
>>  
>>  		/*
> 
> Should we rename folio_use_access_time() to folio_in_lowtier()?
> Otherwise the code is really hard to understand. 

I just stumbled over that myself and I agree.

> I admit that I
> introduced folio_use_access_time() and it was probably because it
> decides the use of folio_xchg_access_time() in
> folio_can_map_prot_numa(). But in the other callsites, folio_in_lowtier()
> makes more sense.

We can just have an alias function if it makes the code easier to get.

-- 
Cheers,

David

