Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0A84C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E22E66B0093; Thu, 10 Sep 2026 10:29:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFB786B0095; Thu, 10 Sep 2026 10:29:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D104A6B0098; Thu, 10 Sep 2026 10:29:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC10C6B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:29:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD52080508
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:29:41 +0000 (UTC)
X-FDA: 85198086162.28.DEC5EA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id EE86F40006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:29:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jFrgqnzN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jFrgqnzN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789050579;
	b=ymTFvrrBnPEdqwCZnGbWQXRLNUiGYbq0touSVhbM2Rai0wC7VxExWN0CzN44vHbQacVwYi
	CXv67zGU1Mp1rxMOtasDbF/SN+1zIY1kMobyBMDQyh4JOkcu7smNmIsZLEHASDF9gfT2bb
	/WAl8yfP7VtHccZ43fjfh6sInfizpno=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789050579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KJRcwygGYVy4dG4Ps+nSG/itUpNyDb3m6x+mKKxOpsU=;
	b=vhVOpq9yL7ieEIW2yQB33z5eA9tCQz1WQb4MFS+QXEmG6+aR8t75VdqbrGGtfPITayvMfH
	sw6P6oUFtwDt2Z7EPzgTBIw13W0wOwmGaQBzcfSKccObJCMQkPH8bEyNyHrFZXPZURgIiP
	2/Ewi9Tn96ynAKVf5OFxaSHS6QEVXok=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DF67600E2;
	Thu, 10 Sep 2026 14:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A84E1F000FF;
	Thu, 10 Sep 2026 14:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789050578;
	bh=KJRcwygGYVy4dG4Ps+nSG/itUpNyDb3m6x+mKKxOpsU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jFrgqnzNMfKfIqZq85rz4WdNfx04C3O3Dp4Bb69/hOroxT7QgNDyLykc3ghRiyvnQ
	 xRXrrOv5ZKqLIutXp2SFgHlLTxEIj2TtRuAdk3UQr74vvNmqbsllhqSPF6n4iclkCu
	 OuTPNZjlnd81hIL3R7K9Af0KytaiIbXfLf5Qb+G5ZD0rjXJe0xAbPSCLfsQDmjg1CJ
	 e6YgqUNul6/tTbVIqy9W8sxPcbx98wgcaT3g16KMoKNG0+Oc1p6uF2zrnpoFW0r8X5
	 UeLr9jrK4Jrb6qYy+TlPtk1IA1czEk1tfoIBfo+TeiiPTPFFYFNm7Uv05CVM0iQ6lb
	 e7BGQ2lLXwFrA==
Message-ID: <86fcc776-b919-4ad9-8abd-a61150dee3b9@kernel.org>
Date: Thu, 10 Sep 2026 16:29:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/12] mm/sparse: rename and cleanup sparse_init_nid()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-4-008fc8d579fe@kernel.org>
 <aqK0S1OT5csJFIq1@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqK0S1OT5csJFIq1@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EE86F40006
X-Stat-Signature: pqdrm95oojtbgu9zdkdupexjhpif478q
X-Rspamd-Server: rspam01
X-HE-Tag: 1789050579-558087
X-HE-Meta: U2FsdGVkX19FtxH9UfpQ0a3cWnqkv2VEMgxgic7hIAnysBZXog54V2ZT5Pf4qZeYz8HUQ7WggmquYsDsKI7hRTiwy4kOMJ28qqZirR1VgTi0Al8EcdPUelatQqVSTFepXoGDv9RaN9t8BWBM8QJ2JXnnNgedtK95EzlmfRVpEtm9RhrQJE9LON829FiN3vKt1KbZ5BJxEX4e6kan8CNsMo+liZMc9XlBITID92TDOtyKanIJHgcEmOPruatN3ktsepy79WqAvvw2p0t53YXWGeM6Yypf24ge5TtHNjzYR54tp+llvuqCxATzJy22/yiR/h1V55MAwWzdaLVgy7vQ+fkh3HQR4kmxfn8ATp2HbANStTa9Ocv5Ld8DotDQoVRpXO5PpjdbMqoo453YD5YN91eOBQ23Br0R1qsrzyhfOEBo4EB8ayBMFFczfjS78KT5pilw7btmNG1aI+UHU7MnMt6AXWOcMNtJA04xGSvsk5WpVsgFligJWX6t3D8cP42CKDhukp4V6K5OT/DxD8ExiMOQQgqYiC6s7zrwOfqFJmVxaSVsFZbxDU4oM61aGCQwaehGKRqmOlPYdTLY1+yCSJfHu5UdPQ6fDYsztrcv88IUYu6Bkb0sFaiJVukbWQcvqttVGTdWt8qtuRbIlI9KCWu9l6vOpGz6ZRCRodAqZW2xKnB19yFKHoge0Urdh1Pz3SBIQ9S7zkfGAAUlhcdgNld3HSDdeB5y883JIB4eZOca91DpniHHbZuYteAMHl/wX4f1Hqokcpj+1BLZH2CSnTsKF0vxXSd8t63DDNJF8Y/nZA+p+Cxy1+7/SXKCELJE661tDGqxHFZVurM6FVbg49XD3X4bORGKN8JCZaiWL4OUEFqCyQdU5/8sXEFnrG0aFfDxnBdyVn88iPTVr52VnuR5Vxy8etnDnxelE+/IDV5VVoKyDKztVAQNsrmn11PGX/KDPQr7YakdF+Ry7my
 XOjAM0kp
 wchp2G9srT/rJ25uc0AaWvSHvKQWhkzL0BUA2li5b9BdW8S9TqFuEgI2s2IHWNaS3JkBa6ogvV8+hsmQ1MiWXSEXzbNeBhG4MdC5SweKfdeAVeoRlvKe6kjA1URgqFsAFQhWD4YN4HriLtiMx/OiGTy3KaXKDCHc+VHNJmA8a8HOdroNboIBzeca5g+iO2MrVtTvSfpj8vRe1c4OXYotkyF7YI1CGdVWjjrgw3O26F1SvLtlCST2Y6ZXrcTHg9biv9vLS7Wrze6o4M0wyRo4sndq0/paDnPGl//JLSv+GUsdS6rsVa+iIOFLYgTyPz6D8eGqNOsbtdXQ1DDc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 15:46, Lorenzo Stoakes (ARM) wrote:
> On Wed, Sep 09, 2026 at 03:32:57PM +0200, David Hildenbrand (Arm) wrote:
>> Let's rename it to "sparse_metadata_init_nid", avoid the "pnum" terminology
>> and drop the function comment. Further, rename the "map" variable to
>> "mem_map" for consistency with other functions.
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> LGTM, one nit below.
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
>> ---
>>  mm/sparse.c | 41 ++++++++++++++++++++---------------------
>>  1 file changed, 20 insertions(+), 21 deletions(-)
>>
>> diff --git a/mm/sparse.c b/mm/sparse.c
>> index a85a9c3840f6c..f84bfceb53060 100644
>> --- a/mm/sparse.c
>> +++ b/mm/sparse.c
>> @@ -222,37 +222,34 @@ void __weak __meminit vmemmap_populate_print_last(void)
>>  {
>>  }
>>
>> -/*
>> - * Initialize sparse on a specific node. The node spans [pnum_begin, pnum_end)
>> - * And number of present sections in this node is map_count.
>> - */
>> -static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
>> -				   unsigned long pnum_end,
>> -				   unsigned long map_count)
>> +static void __init sparse_metadata_init_nid(int nid,
>> +		unsigned long start_section_nr, unsigned long end_section_nr,
>> +		unsigned long nr_sections)
>>  {
>> -	unsigned long pnum;
>>  	struct mem_section_usage *usage;
>> +	unsigned long section_nr;
>>
>> -	usage = memblock_alloc_node(map_count * mem_section_usage_size(),
>> +	usage = memblock_alloc_node(nr_sections * mem_section_usage_size(),
>>  				    SMP_CACHE_BYTES, nid);
>>  	if (!usage)
>>  		panic("Failed to allocate usemap for node %d\n", nid);
>>
>> -	for_each_present_section_nr(pnum_begin, pnum) {
>> -		unsigned long pfn = section_nr_to_pfn(pnum);
>> -		struct page *map;
>> +	for_each_present_section_nr(start_section_nr, section_nr) {
>> +		unsigned long pfn = section_nr_to_pfn(section_nr);
> 
> NIT: Could be const?

ack!

-- 
Cheers,

David

