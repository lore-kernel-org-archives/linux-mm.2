Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE259CD8C92
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 12:55:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56DAA6B008C; Tue,  9 Jun 2026 08:55:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51E8B6B0092; Tue,  9 Jun 2026 08:55:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40D7C6B0093; Tue,  9 Jun 2026 08:55:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 340396B008C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:55:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4B24164A0C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:55:15 +0000 (UTC)
X-FDA: 84860369790.14.EA5039A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id E664B40011
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:55:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hmcc79SC;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781009714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8GHDf/RVnBCewcZpKZyqB+pri2BC8nwPoR8xvqXHq9k=;
	b=wPhZaLnnE8e49t1Tn0BzteQeRVgVgO8cNaUiA/mWoVt+sZK8jtqd7dx2H/7qZiI5k1D9dE
	9htkfmLJdndAvPxPgb48Xm9108fLqs/JkNnjzS1yE4N2mDPouiC2CBumc+ij4Y98/H2634
	n0V/5+iHVYnQZspQp0NypzC+8gdaDKI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hmcc79SC;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781009714;
	b=CwnDGYItWU1wdMuo1Bv4GLKXjuVDMjFEdXzwiPATkzlMqu6+AaNzii50ZgK4pdbikvc/iw
	buMwwXJMjocvhIdil5eAl2yh9gCXso+ngcrXwnYPzSKCAhSg7jZusIPQIYqkdB3CUmEP0g
	sYAL5G7bcfzpxrLKwirNpmgYcDbXW3A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 10158417BB;
	Tue,  9 Jun 2026 12:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1B31F00893;
	Tue,  9 Jun 2026 12:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781009712;
	bh=8GHDf/RVnBCewcZpKZyqB+pri2BC8nwPoR8xvqXHq9k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Hmcc79SCMgkni+sJcI/8+5HS+mWVebR4K17jduHY+OeIRwe3RK2DsWPisDmo7IwUP
	 ioOp2IvwyIMA9FPmBE5YoQhvULFL7z5bpL4wPfIDMrrs0DVAvrfZCHn+xzYouW6v8U
	 OnQgP13ik5xmMRTLDqGyp7T76KG1QI+w7o3ZAsg54n1pHo8ihKtwCfUq5N6WiYvEZ3
	 Eq3dFy2qF9ysM3jnm5Dzgg8096y06bJzaODWjkYoIebQgh2D7kpKk1cnHpdUcUN2D1
	 J5L2VQvvvLeMURZ7t9ugzOi4gr+Hrl54Ri8knQSZE9RvKaFQFY5/T+jqMz3bvk/vBV
	 Q/MaQyh+3bOKg==
Message-ID: <fc04914d-98a5-430e-bd47-f7100db75e69@kernel.org>
Date: Tue, 9 Jun 2026 14:55:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] mm/migrate: skip data copy for already-copied folios
To: "Garg, Shivank" <shivankg@amd.com>, Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, kinseyho@google.com, weixugc@google.com,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 willy@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, dave@stgolabs.net, rkodsara@amd.com, vkoul@kernel.org,
 bharata@amd.com, sj@kernel.org, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, jic23@kernel.org, aneesh.kumar@kernel.org,
 nathan.lynch@amd.com, Frank.li@nxp.com, djbw@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-8-shivankg@amd.com>
 <810e9a58-9c08-4f5e-af5f-866685ca09b2@kernel.org>
 <a36348d0-73f5-4599-8d06-c9472d0b8d72@amd.com>
 <7e6a7626-5a1b-4672-91bd-85b0f4ee2ecb@amd.com>
 <7430d69a-616b-40cf-a2e8-6ef4e57b6857@kernel.org>
 <F496EB0C-B329-4A61-B4B4-0D434563281F@nvidia.com>
 <c9d98321-60be-4cf7-998c-7657d93fd683@kernel.org>
 <f255a2a5-7bcf-4627-b132-380485124f0d@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f255a2a5-7bcf-4627-b132-380485124f0d@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E664B40011
X-Stat-Signature: g57zofy6dzbkj98ea5mucgizwe5tg83w
X-Rspam-User: 
X-HE-Tag: 1781009713-124185
X-HE-Meta: U2FsdGVkX18b2FxoPk65XGgGxpDAqiOwiGpIgA3Dgy7clqreKzPN611SKNqu9EjXCldlKclyttnCmlH3Fmi6b4TrsotdpRbkp+dXmMgkPIA2MLJoh8FKIDlGLXOmYbR2+NvYzmyTHwJDHWsARXfrS8iyvs+kCigbEAtedSHp6L5HuC8c8AN+ligwK2Vyj8+EbtXyBnMvJnrGZof9DPMF5jP6EdWPAQ9J4AxsCpkNCpkZ46InAGmCyVO2c7we6aH53ryP9Wvgomjj0X3BMaiXhWfg3QJebtdeV3eCgOjOCj8CS5YSsGg4jrwvS0KaTfxIyQCnZd8jACsBFZXakiwcXlK6yFCrzwAL6NHy3unMkzLBa28mAPO89DiVnWMD3jNf6pz1fSK8Y+sUwcIr3KU9c5OxU8xLys4jQczU+HZnCVAHEDW4CpOdhSXHvQpLjQQbQPWqcncIrlH7JoZqFQjwqm1frk3WO+Z008zYhrMUdOxtPnsGXb1NP6dhGUkyOol+VtNtU1g8ePMOgRHBacTdxs9du0bsDZHKUS66sVMYt22YRKBFmKD51xi3F6o4gVLdmFz1KC5K/AY2BBJl4MdANQif3a3V/lb/8SE6DcIC2aB6XKlcyjfq2EKNwtmbg7nb0zgmEk9RcvR0aQXC9ylPBwyCwutzbcLpXVewUhyZzg8jpXAa7AIAxYGWPMUZfljN6O2bZdQ1ENdLUP+ypwZmsrJIvnMX3b+UakLjj1MywdmQN9j2lUeUr40XbdLy2/QxNLFexQXzBgEAKvM3tEGVeq6Fk09xO5qUHsK1uVnhyMXdxjqIrU+cbbESTcfIywvmNfYhGVid5ygXR2SWZS1ghftyjDFRHRzp9gsxuffDRKmu20jzMuo+lrVTC0VD1wP0G7zE+B371SNI2Ocr/GZREpBrVrPBdRNQhxnCgJ8FVhrjLXlHOReB4xiRArPoY6hl9WIezVGoHrPzCcXbaqo
 ltaMSImb
 m9mXBK3yrd0llmIse8Cciahxnxjxs7gF5BBOGIjmKuAW/lHHY+469c7AaVQn9dDVQu9K6NSP93vrpcehajYkTaMRNr+QnOuxjwSjmAj7g/isA831mgGyakXrPSWmeRjMtAyWeczVQU6apd/FrRSHnr4qcAwW3o76w53/HzSX3c4vEIjA+mXLrlI5CruVnDQxBFncF/BlyQaNbptuhz88oQke9z53mPoU/kJSeDlyqRGtcpJbUr1lu/1Fdd3OWj0w/cwxZN0AqiIYsaD46zfJjS/phdNSOcJU9TvSaq+pY6fGoYBHYTqdeTgKDsQEK0Jh0QpuuA7A3infCXX+mGujojoKqUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/8/26 21:32, Garg, Shivank wrote:
> 
> 
> On 6/8/2026 9:13 PM, David Hildenbrand (Arm) wrote:
>> On 6/8/26 17:41, Zi Yan wrote:
>>>
>>>
>>> IIRC, multithreaded copy is already gated by CONFIG_HIGHMEM, otherwise
>>> it needs to perform kmap_local() at each copying CPU, which complicates
>>> the process. Then, this code will only used for 32bit without highmem,
>>> I assume there will no page copy DMA on 32bit platform. Maybe it is not
>>> too bad to limit this to 64bit.
> 
> I agree.
> 
>>
>> I'm more concerned of CONFIG_64BIT handling in the code, but if that can be
>> avoided easily, fine with me.
> 
> 
> MIGRATION_COPY_OFFLOAD will not be enabled for !64BIT at config.
> config MIGRATION_COPY_OFFLOAD
> 	bool "Page migration copy offload"
> 	depends on MIGRATION && 64BIT

Might we worth documenting somewhere why, like ...

> 
> I think only place in code we need #ifdef is:
> enum {
> 	FOLIO_WAS_MAPPED	= BIT(0),
> 	FOLIO_WAS_MLOCKED	= BIT(1),
> 	FOLIO_OLD_STATES	= FOLIO_WAS_MAPPED | FOLIO_WAS_MLOCKED,
> #ifdef CONFIG_MIGRATION_COPY_OFFLOAD
> 	FOLIO_CONTENT_COPIED	= BIT(2),
> #else
> 	FOLIO_CONTENT_COPIED	= 0,

... here

/* On 32bit we do not have a spare bit, migration-copy offload is disabled. */

> #endif
> };
> 
> With FOLIO_CONTENT_COPIED=0, this will be no operation for its bit operation.
> 
> eg:
> const bool already_copied = dst->migrate_info & FOLIO_CONTENT_COPIED;
> evaluates 0 for !64BIT.


If that does the trick, good!


-- 
Cheers,

David

