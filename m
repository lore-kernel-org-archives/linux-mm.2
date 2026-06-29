Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 169E2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 06:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BFA96B008A; Mon, 29 Jun 2026 02:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16FF76B0092; Mon, 29 Jun 2026 02:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 039936B0093; Mon, 29 Jun 2026 02:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D08046B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:36:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3D9E8405C7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:36:00 +0000 (UTC)
X-FDA: 84931990080.13.A433634
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 86AC9180006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:35:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782714958;
	b=iIHVld3slhNOtdNdnfDqDNqIfGABinDDwGEjQ8v7w6APwRuzeQybROi7iboXwoNHWJz6T9
	lX964yXy3ZSTdRYe2U8VjYdkS3WBWmJlaE2Mi5Cj3Zpucl/JZUkEFi07lHgjo/fmbYg9bZ
	RW9D0j4OpHum9yQoaOG51i8F+QTEoSQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782714958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ziZF5MjDBHEwSrU5Njn2F9RHVQMfnkb8O50T7BHAiB0=;
	b=DhDh/budLc/43myNrTllAIlqIJ2rhcH1XZOKAk0PcRLtIfIo2isC0v0JZzD9IlnI9h82MX
	/0G1G0FKZxMO9j/TUeGH7d8TthL2fya4P5trblpJfegL1JrYfH8rRQietnWlO3LIX7QEbp
	Hv7ishjwJ6vjmxbjaNnplmHOgWjHk6w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F334C60052;
	Mon, 29 Jun 2026 06:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EBC1F000E9;
	Mon, 29 Jun 2026 06:35:52 +0000 (UTC)
Message-ID: <0404b7af-2785-4518-827f-9df0f30564d9@kernel.org>
Date: Mon, 29 Jun 2026 08:35:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] mm: assert exclusive nid/zonenum bits at the
 page/folio access sites
To: Andrew Morton <akpm@linux-foundation.org>, Hui Zhu <hui.zhu@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
References: <20260626020629.1042041-1-hui.zhu@linux.dev>
 <20260627213031.88e3bfb3489553afb1102399@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260627213031.88e3bfb3489553afb1102399@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 86AC9180006
X-Stat-Signature: x6mnhg47rjf8u7f9zfiku9thrteno5hx
X-HE-Tag: 1782714958-136834
X-HE-Meta: U2FsdGVkX18+rPg9WJQxFcff52CB2aY2D7EN66NXheypTJfp/WLpnCWEFD6/nTNg9eP00xU9L6Cs2TjQost2ohXl7z9Rn4vww2weSt0WrAC64zqlWtQHRIwlreMyieq0iiH3a8pzLH82i9S8ulQV0NnJOYl15nd4zgHDxtkyCbc9uJ5TYe9VyBoFeyXwvsPqhuiqUXI//Ne3RsUmxrboN4NSU0sIHJfaDbcYNkvt+bfA3z5Br0wagkWZHeiN322lwa+p0kCh5dKND1oGGr5TmQzJ2xPUZxptBlzNGF1MHwB4GDMYhBEAxmOXEFt7jJYjZlDZWGRSOxHYualRpkVhgTp1zFqj4mF0TB1I0eyjw64jjOU553kl7jWZCsLisLK7s5WYzq/RLZv9jpgetTZKeftT5fSUTyRxgmtdpLECCk3XwM2FYlAYHcppilRi5GpYoNdW1q/7hvUzRk4ZGmZXv/8dYNxltdPiOJsFNk7vjTjtzqRL9ZhZcYPDT7Ejy11djgyL/03Ypow30SiaEzbQCfXvsl3aUFJMBcIp7ldxOBrzBKi/wsJ7aS3IIv8VCW/wJT75W6pDTMZU7xIsEBw7I7Ohk1lf5e+uN9WkStSNJrJfEioTIF4RzrsA7Ff9aRQtLwbmoW1VuHS/opNw4oz/o4JShtAQaQZp3yENSRo8LVRsp8JCiXX+3xJNErlRSEjbvMZq+lphyYPNV4IlW4eLg4nkASQsSgn6vvXsep4ISKGm58d7qdJ235LeEa7ooGpPQYU2XOzg+Q2hLxdxlLV73EJOo64B+Q8oB645JRN1qiyUhteKFSYkAzXXkpPL4FaMPfytcEIOYmuDuPotIGVMsknoEPA2sAaVujtHHG5fRAJoFVHxfosc67vQHQNTYkbHBmPEKmPMEZXVimj7jko5GNz4g4o0FWNfeAnnF2XJTrotVwaD7zpTIKZ6n0F0/kyDvhacfDAtRYXthjyRBp2
 ttJCAcal
 NnCD0z5GypSZuRUgLKOI3crC+5JZjpTM5WEqOZmVn55UlUAguoOGga7wuqz8MfNUVgQM5Jq0W6fPlyjJOhXBXlYrZsyNtYSnUut2iTPsHf+n/8xFzxUehQXn+1h6YdmHU0P5XymVdpSC5ZUkcexh6iPTWyLvgyqM7/dJBMDxVQ+YZjyUenYBVs/OHoDYXQVHU/d/ptkSw4n2RYOk1wixsLYEvvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/28/26 06:30, Andrew Morton wrote:
> On Fri, 26 Jun 2026 10:06:29 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:
> 
>> From: Hui Zhu <zhuhui@kylinos.cn>
>>
>> KCSAN reports a data race between page_to_nid()/folio_pgdat() reading
>> page->flags and folio_trylock()/folio_lock() concurrently doing
>> test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:
>>
>>   BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp
>>
>> The node id and zone id occupy fixed bit-ranges of page->flags that
>> are set once at page init and never modified afterwards, so they can
>> never overlap with the low PG_locked/PG_waiters bits touched by the
>> folio lock path.
>>
>> ASSERT_EXCLUSIVE_BITS(mdf.f, ...) inside memdesc_nid()/memdesc_zonenum()
>> used to check a by-value copy of the flags word, not the actual shared
>> page->flags/folio->flags being modified concurrently, so it didn't
>> reliably assert anything about the real race.
>>
>> For zonenum, move the assertion out of memdesc_zonenum() into
>> page_zonenum() and folio_zonenum(), where flags is dereferenced
>> directly from the page/folio.
>>
>> For nid, turn memdesc_nid() into a macro instead, so the mdf argument
>> is expanded as the caller's own flags expression
>> (PF_POISONED_CHECK(page)->flags or folio->flags) rather than copied
>> into a function parameter, letting ASSERT_EXCLUSIVE_BITS() check the
>> real page->flags/folio->flags directly.
>>
>> On CONFIG_NUMA=n, NODES_MASK is 0 and the old memdesc_nid() body
>> folded to a constant, so page->flags/folio->flags was never actually
>> read. ASSERT_EXCLUSIVE_BITS() is a real runtime check that can't be
>> folded away, so doing it unconditionally would add a pointless read
>> of page->flags/folio->flags and a check that can never fire. Keep
>> page_to_nid()/folio_nid() as plain "return 0" static inline stubs
>> under CONFIG_NUMA=n instead.
>>
> 
> Thanks for persisting with this.
> 
> ASSERT_EXCLUSIVE_BITS is defined in kcsan-checks.h and I'm not
> immediately seeing a reliable route by which mm.h and mmzone.h get to
> include that file.  I don't think kasan.h gives that to us,
> surprisingly.
> 
> Unless I've missed it, we're presently getting kcsan-checks.h thanks to
> good luck.  Let's not rely upon good luck ;)
> 
> 
> Also, Sashiko is saying stuff again.  Does it look legitimate?
> 	https://sashiko.dev/#/patchset/20260626020629.1042041-1-hui.zhu@linux.dev
> 

Let's see whether pass-by-reference as suggested in reply to v7 sorts this out.

-- 
Cheers,

David

