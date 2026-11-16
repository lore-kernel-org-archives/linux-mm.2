Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F25A606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kgsU7v3s
Received: by kanga.kvack.org (Postfix)
	id 1F4D86B05BB; Mon, 16 Nov 2026 10:18:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A5496B05BC; Mon, 16 Nov 2026 10:18:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BB686B05BD; Mon, 16 Nov 2026 10:18:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D72126B05BB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:18:31 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4A6FE120153
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:18:31 +0000 (UTC)
X-FDA: 85441338822.22.6D44ECB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 73DAE80002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:18:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kgsU7v3s;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794842309;
	b=KTEt7hFhynzY4EMZ6mT7Jw0vihyvIhEET5Pqg9fdVKaxiENwVj23d5tkR45zuj9wrzsPEV
	JmPq7/y1c9eJJEY7/CMP7mHlJeaW2Zj4/ghAPVniNRTKKzxhoyJNIDvBSnYjajIkqmyiXV
	DGGvV/gYyu9QeZyIUPzYrV6wiXubrcE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794842309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jlvZrVhOkdeTk+oowKlcepHooMPcMMjRTAtKw9L9Q+Q=;
	b=8XvCn9s258RultuB5YcoT2BOf3j3qG74vHcokVNgWJlqOI6mWkQYJcnN18vv22jtSKw3Uv
	0kMOdV771FhTRnYeK/3Hn+O3NkM/3Pgup+/6pIW8opNYNL12ftjXao2Gw1sylNovk9pKVk
	ISEwJqbTplVsTMWoA0z7TSoFAwRsfBY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kgsU7v3s;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA80243864;
	Mon, 16 Nov 2026 15:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEF81F000C4;
	Mon, 16 Nov 2026 15:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794842308;
	bh=jlvZrVhOkdeTk+oowKlcepHooMPcMMjRTAtKw9L9Q+Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kgsU7v3s433NPHhbBi8chwQuS/6xMAIsLfz6t4ODCB69QCDxqQv5DYulycfrI0k/w
	 syTvxVo83FnOihD/eGTd715sknQU3/HwORy7UvoVyUDsS9yBdbpV+EwAUITbBk5w6a
	 AEdUqvd4GBZPsRjrlGsnD881rg0zj2/2m0oJh+zCuoYy+wzTNkOHQJGF7yxEkgaCtA
	 FmKtOO0TSgnG8MndOPtp8gHmBSKLuZQg9eZ7lPzwh86LEJAIuKo5+YPr8NcRAxvJOu
	 wLo0L6b/LbMMkDcoZiYL83ISmvebgbDMBZoJM/nQoT+6O+qdTgdoVz1hpf0po/U6Jn
	 jkupeeeh8/C7g==
Message-ID: <5b757f20-9768-4d3d-8c41-52c1c9671fa7@kernel.org>
Date: Mon, 16 Nov 2026 16:18:17 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/mmu_gather: delay rmap removal on UP as well
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Will Deacon <will@kernel.org>, "Aneesh Kumar K.V"
 <aneesh.kumar@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Arnd Bergmann <arnd@arndb.de>, Johannes Weiner <hannes@cmpxchg.org>,
 Hugh Dickins <hughd@google.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jan Kara <jack@suse.cz>, Ross Zwisler <zwisler@kernel.org>,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261116-dirty_file_pmd-v2-0-571883053174@kernel.org>
 <20261116-dirty_file_pmd-v2-1-571883053174@kernel.org>
 <avseFdmK8zN8JTNe@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avseFdmK8zN8JTNe@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 73DAE80002
X-Stat-Signature: dgu5oqfhhfgpdkoq8y3siii6ujz1zi6m
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794842309-484184
X-HE-Meta: U2FsdGVkX1/at++Ln/m8mncqX9gx02EsuAnvIXtHYBuQWl4sBpE6OC82ZLW8dY6lImQ/LEz5FGEQ135Syu4V5iENCs8sHyJ8QIpkd2FQTskLo2D7ZaF8qN/96laKlxo77kCgl/VRU3Z+nXxV1r1QIHLCrNRQYSUiVf+2QEQ7UpwbrUf1WKoAiYRxP8cttGLOJ+dHf/APakW5g4NWOZwcDSxCT94WbGW8VOdIYFGll0Naaf9qUqQF016n0NC8LGPJX9tWlgR7ot6vUOTEp23PgKzkRGjlgzSsccTtEJDxKLmC91mdzA6dJ0aeqDp+z+R3HaRUs+Dxd6ba9XfaZdDDe68/yptOsAMZuhQ9pangHPWvzBZwSifGkTuCqhhQWJH8shS7sFYTQvYKZab9lqsTqjHuCTF4OYC/rqNR5d3Um7pMPo1aTt7YkvzGsHs5fEwHG/FbccrhMznxcFIUGpde9+N9E+7XEYqFlZxfGiW3auWJYrY3e5xjpgsEurWUG74vl40Z7mwYJlzEOKUy2jq59c5RmYsGBvcR0XWDEWnxYctt59Zh4dLBJYz2rCRoQuFz1JTst0SoejaJPIyBF3r1FOw6J5kXjCgAinmnpxczEEjGOstDS16TDbChnC71YlQw1WnnwcJy8RCFlcz2hOIxXKMiBSFKII9S8Aki6NLWDxMjmKopC040U83PU7NR0eDtEAy1xabkz2icDTYY+9m6RF3k5LO/sKk/FUXA7t1vqihey3WNh01Fho+bs25k6uzw2kYJvH73QP1H82/Pk/uJzR0DIGuOEKMF1ZmYnxmq/ion8BJexMf41a5rlaxkMTA/dXushUlG4st1KUGltreRMi37uwApawSO0EWd8/K3UoTwSvumLOJn1ttlOJXJgdhuRRYEI9M76YI5D2Q0X5w0ISJPu1UtuOdpHM/1yhu1e8RLx8XXTI6+ICxP0/s+J88oPCD2B+NHczUPA6Dx4wB
 +qL144AM
 MUL6R5XdLV/AXoxhUoZmbgRUIMuycQ3tKrAVFQQJzpj7gXFwP1L4SomamK531ttpUvkIST9wE/4S6o2SfKvD7ZzmBkhPdduiKrse8OO5JrznVmZRObWS3Ob/B/3Co2/F2Da3msvoBp5Ax+8E5Uj3zYeKjlzzkQ4jI+SPPv8+PdxulTEB6TocD3k76s3q5928C3wLYLzknPj9uAE5jo5ct0CuoRUdi2Pb4Bn+aGUDpVt20TwNjnN04ux2GwQbjVSTLswApuzekRxrjIgDNhap8Z90NNPoNKsOMNa+C2CP0xrkwPFbb18BU5rewNX67UIWvUww2NqdVxzI8FkeC6g4kCAVdE+XJLolGnRdMangagf6v+lH4sZDOYbI/1dsjpMceiwdXzBvWE+cWYEOX6OsnHgaDVkW8jHLgf+0PZrTyOSNuJmeMySIwi6DxqFvF5FJwEpox
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 16:16, Lorenzo Stoakes (ARM) wrote:
> On Mon, Nov 16, 2026 at 04:06:58PM +0100, David Hildenbrand (Arm) wrote:
>> Commit 5df397dec7c4 ("mm: delay page_remove_rmap() until after the TLB
>> has been flushed") introduced delayed rmap removal of dirty pages until
>> after the TLB flush, so writeback cannot clean a page that is still
>> writable through a stale TLB entry.
>>
>> It skips this on UP, because on UP there are no remote TLBs (single CPU)
>> and because the PTL prevents preemption.
>>
>> The PTL prevents preemption while removing the rmap, but the local TLB
>> flush is usually only performed after dropping the PTL.
>>
>> Consequently, after dropping the PTL we could reschedule to another
>> thread of the same mm, which does not flush the TLB. A kworker could
>> then run into the original race with writeback: it cleans the folio,
>> but the other thread can still modify it through the stale TLB entries,
>> and these writes get lost.
>>
>> Fix it by simply not special-casing UP. Now, only architectures that
>> select MMU_GATHER_NO_GATHER (s390) will skip delay_rmap handling.
>>
>> Fixes: 5df397dec7c4 ("mm: delay page_remove_rmap() until after the TLB has been flushed")
>> Cc: stable@vger.kernel.org
>> Reported-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>> Link: https://lore.kernel.org/r/avrxOt_GyXLXNqtR@gremlin
> 
> Nitty, but I think better as Closes? :P

Ack, fixed it on #2 but forget it here ... why does checkpatch not complain? Weird.

Will change when picking :)

-- 
Cheers,

David

