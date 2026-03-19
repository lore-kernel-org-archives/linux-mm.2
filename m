Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F259107526F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 07:37:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D25256B041C; Thu, 19 Mar 2026 03:37:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFCF86B041E; Thu, 19 Mar 2026 03:37:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C112F6B041F; Thu, 19 Mar 2026 03:37:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AEADF6B041C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:37:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 480F38B713
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:37:22 +0000 (UTC)
X-FDA: 84562007124.26.3F0B97E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4CCC440006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:37:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YctH8PgT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773905840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C5tnDm/ABQNsA6CFGfkj3pj6REkShAprpbEVsTtFZBs=;
	b=Z8TBqTYagK+Nc+H634sGaitw7VDcKehcJvbhoMOd7ftqD3N851KQbr4OXvetvqYBQA+0nj
	WAIehOwsGmnZWwE/qYuY/KSgSr5fRgjvTe1H/N040SkVQySYSsZyHHeLFUh+uYhgggiFml
	BWsXUgeNzrqU5ixhY3h1/3lF2XgFnqo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YctH8PgT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773905840; a=rsa-sha256;
	cv=none;
	b=EpTZgYWkX/O4EUlef/EokySjH1KS7H1L0cYjSMsELAaxTrNX95A+vQCit29rqsIgfxfnIl
	lbiLP8dYkSmr0YF40T6TE19Jy+iJKY4TcthMaoXsck9ocGOtdWoBiwljivtbkPuOItScpE
	ICmZf6tA8r6eFbe5SaXFScj7Tk8wPQM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A11244353;
	Thu, 19 Mar 2026 07:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B68C19424;
	Thu, 19 Mar 2026 07:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773905839;
	bh=qRMfpUzApsAdbW6LZfIeTNJxNnO9wM97sAR9cQMuBA8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YctH8PgTgpS6wXB6v3K+szH6x9HccNE1bv+uHpSJyoU2sXQx0hQ5OgOGBSa3Pf2nm
	 ong8+NvmImY/tAM2kRCyTGGfP9xIFQ067cR07TTgslPzQwhz7cJN0TJID/rq/C+ddG
	 pvw3n6bp5QOvVL8V4ekLUrzUn8wkUAA6KhRWEXocepB2YmxqaJ+qYp0zbeJI2DeiF3
	 PZLcxwNnvYV77PxZfKY6EYlzJkDxqR9R/s5AUGL3uDtdioKcfy+GUhmwc6VGBURkLE
	 R9Y3RGplEaLwOKHy3HboLnM6CoKDSQPIJxrjC7r/eLTZSrcEmmZuyYPSzYlPpb4GeC
	 OcTqoGnrs6mYA==
Message-ID: <6625614e-457d-4e67-821a-8bbc10a22c0d@kernel.org>
Date: Thu, 19 Mar 2026 08:37:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: bypass mmap_miss heuristic for VM_EXEC readahead
To: Jan Kara <jack@suse.cz>, Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, ryan.roberts@arm.com,
 ajd@linux.ibm.com, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
 catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
 kevin.brodsky@arm.com, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, rmclure@linux.ibm.com,
 Al Viro <viro@zeniv.linux.org.uk>, will@kernel.org, willy@infradead.org,
 ziy@nvidia.com, hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
 kernel-team@meta.com
References: <20260310145406.3073394-1-usama.arif@linux.dev>
 <20260310145406.3073394-3-usama.arif@linux.dev>
 <wwaqkpuvvrnp4obj6nyebbgqvugjsmelbdkunoiadqtebh4zr7@ckyn5taaz4jy>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <wwaqkpuvvrnp4obj6nyebbgqvugjsmelbdkunoiadqtebh4zr7@ckyn5taaz4jy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4CCC440006
X-Stat-Signature: yatmj3fawh5pi38xw7ikg7um36pdcd3i
X-Rspam-User: 
X-HE-Tag: 1773905839-270793
X-HE-Meta: U2FsdGVkX1/8PjW832PihqF0a7lMQJsf+sqxEIYA/pBZDkwZlrOqovlnpQmIe2GqnUjHQDBlkhX6vyX8eOtqNuDeaqLZTxlwDzbCK+X1rv7E60m8mHVQIKshoMlzx1k+1iXmlDPY0MH1quxGMYpnwf9kDsLD0p8feQ/FL0VNn2a2BBTCbUjZy1/W5R9ziWvTgIEt4dOztew3a3uLFCpQyYxYxKTWElPJaYjOK/Q5zMd50KcD+OdpWkexdxHxbYpIkzZcf6U196jWta2jk6xkMunOlHuVOBSwnMeSYn7FvsLSinN3LLyyyNQwDfXKrvB1UE2ZEQOtizdVJpABjwtigVUVlGt3+K640NIuXpulG0CnkmmobQsL4tZxPqeu6f3AfPsLqnmoPXEWD5+9LjgqIPUWzTnprqLSsQdmIU6Dgu/UXVslWnPh1nM9M/LOwad/7UyCR8mIDiAZsoSuxBzs7Fmwt/VhQlMpEkIUlOznYChexUQe9E43PAQv6QzOuSs01TMruIrhbLClsuIFMvEK++sbpDitWtiuXE1jbwPySdLj2jYMKBScMem3sFP0DbbmHeDsUK++buCGPHEsGL0Uczmr4xR0chjOfycRepx2PInFF4ojoOfQyhoCZc0WUgcYVA3jQEhl7Pe1f1geCwjgYUIOyYPf/6Q4V7OpOZjqbyKKM/AbQ5eZKSJ8RfV15M0e9pI2oliopIBeCFjIZb1PunbHjfQk+eL6v1C+/Kt0fq86vcMwOGVN8g8uGnV96SU9xr5/NqOr35hz97a6VoJEQ8Z90fqk/ne9kzZp7CdoXBRbbTNNfmojrprVP2nqP8npWWVAa8DjKsTyu8o1WrKp6TAwRJAuGyf/M20aqyEGEazBLtbgBQHpS5LjfZ/Y9SR9f4qr/vE+bZojuZtwzaBpspJnZ/4RRAj/5/UjXhvbufHMW8BrAeDbLwei4QGB/+0YfdYIt2EQ7IttpwMr+PQ
 3XAzOupE
 UAxkS7ewYbb3f9TBWxXcJCh51lBJiyBbACv7ikLM0FGGKD72WDlIqxO+sq/WcAJ33sGEbo9x9zIoLO9OE/OC+zML1s0yKp3qaFCJn8gDjvGsi1wRngQmCvXb99yqVbSqIwzwnQMj+NFVkHLwWhf8K5x3oX2VlFAmHGAytQYm3A+tOl64sbeeuKX+6WO3rrP04U6Bi7HeOepEh8BKN9OkO2qN9epHpb4LY9Sde1n/ixZTN8ffnt2daIlwYD3p768Mt6b6lasu7Qk7979Akj/4qEKRNFePJXEIk+udRAashq2xSFUzt0LHkeU5qEFMwyxcjvwQVhosIs4/UgP1wXC2bL1TVW4yRrqA8++tDzVq4SMwWj/g02feru2xYBPXryuEaqMX5jqFqwhN5rWs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 17:43, Jan Kara wrote:
> On Tue 10-03-26 07:51:15, Usama Arif wrote:
>> The mmap_miss counter in do_sync_mmap_readahead() tracks whether
>> readahead is useful for mmap'd file access. It is incremented by 1 on
>> every page cache miss in do_sync_mmap_readahead(), and decremented in
>> two places:
>>
>>   - filemap_map_pages(): decremented by N for each of N pages
>>     successfully mapped via fault-around (pages found already in cache,
>>     evidence readahead was useful). Only pages not in the workingset
>>     count as hits.
>>
>>   - do_async_mmap_readahead(): decremented by 1 when a page with
>>     PG_readahead is found in cache.
>>
>> When the counter exceeds MMAP_LOTSAMISS (100), all readahead is
>> disabled, including the targeted VM_EXEC readahead [1] that requests
>> arch-preferred folio orders for contpte mapping.
>>
>> On arm64 with 64K base pages, both decrement paths are inactive:
>>
>>   1. filemap_map_pages() is never called because fault_around_pages
>>      (65536 >> PAGE_SHIFT = 1) disables should_fault_around(), which
>>      requires fault_around_pages > 1. With only 1 page in the
>>      fault-around window, there is nothing "around" to map.
>>
>>   2. do_async_mmap_readahead() never fires for exec mappings because
>>      exec readahead sets async_size = 0, so no PG_readahead markers
>>      are placed.
>>
>> With no decrements, mmap_miss monotonically increases past
>> MMAP_LOTSAMISS after 100 page faults, disabling all subsequent
>> exec readahead.
>>
>> Fix this by moving the VM_EXEC readahead block above the mmap_miss
>> check. The exec readahead path is targeted. It reads a single folio at
>> the fault location with async_size=0, not speculative prefetch, so the
>> mmap_miss heuristic designed to throttle wasteful speculative readahead
>> should not gate it. The page would need to be faulted in regardless,
>> the only question is at what order.
>>
>> [1] https://lore.kernel.org/all/20250430145920.3748738-6-ryan.roberts@arm.com/
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> 
> I can see the problem but I'm not sure what you propose is the right fix.
> If you move the VM_EXEC logic earlier, you'll effectively disable
> VM_HUGEPAGE handling for VM_EXEC vmas which I don't think we want. So
> shouldn't we rather disable mmap_miss logic for VM_EXEC vmas like:
> 
> 	if (!(vm_flags & (VM_SEQ_READ | VM_EXEC))) {
> 		...
> 	}
> 

That sounds reasonable to me.

-- 
Cheers,

David

