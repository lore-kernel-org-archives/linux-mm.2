Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F23F1125823
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 13:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58ADA6B0005; Wed, 11 Mar 2026 09:57:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 538F96B0089; Wed, 11 Mar 2026 09:57:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 419E36B008A; Wed, 11 Mar 2026 09:57:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 205AF6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:57:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AD61E139688
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:57:23 +0000 (UTC)
X-FDA: 84533934366.07.D2EB2E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id AA1241C0011
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:57:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ThdfCY7u;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773237441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9X+P6xh1RRwRS0BS6v9pl8/dn7CGCNu57hnaPYTTGMI=;
	b=QShRb5TFwuqrHDQSBRkR3xzQBYUlF2Ubj2Kn/LHNV2Usl0aNlxuXIPxeL/g7iCJ3h9yI4R
	mT5mfP23zoARXv5ky3/PGxszThUS9TuXyF1O9zAtX3HwSSB8PLE8h8lzrRpLkjvkMQbiqj
	yc7Tq9JR25bcSXTXFs8WKLPoRPh3bvM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ThdfCY7u;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773237441; a=rsa-sha256;
	cv=none;
	b=0hGylXDaIor6tZeeHohXBhwhVfiOIbIWr1649GdfJsYh1Hefl6QP3u+TZF4V6IUY+Gr8Qi
	AEEFpSTQYqueOF/29S5jqbokr6NInG5XXMgS1IC2feie/c/uHiuDM3IaFE6KEGp+4Eny2S
	J9SFyMOmz5ekQ9lOW6Rh+vKn982opKw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4AD68439D6;
	Wed, 11 Mar 2026 13:57:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453AFC4CEF7;
	Wed, 11 Mar 2026 13:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773237440;
	bh=FufJY4hvTCH40qFLkuAK2NFVy71xbnZqN98KKnD052s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ThdfCY7uv+bCmSMV0tDzf6VHVA6Jdq9XCJ+RRUYsmyC8OV3SYwg2agPWYsoJkT1hs
	 NXctXTMpjZMDBVaWzYrLsQc6ibzOn3JMEYneFHA4YJQXdbpwuAj8iW7a9mRHJCZENv
	 ycv8hQgqpCPRxCUIVE1fi+2sQs0DVfe8+4gGTt1JfujcfyT41J/2E9fkU/74c9cRk2
	 iYjH1+abmn4GcSECttN30LIj2KDjX030XG6Gh6z2GWivGTXlCcRH6+3oaCkAjF258i
	 +cWKoMyEugZ2xSLLklhvgVw5kze4EAvzLhM4NZSxN2F5zgg5B42A3x0Qj7ThFMNhOY
	 MnAtuI1Wr829g==
Message-ID: <6678200f-92dc-4ab4-8bc0-d956bcea528a@kernel.org>
Date: Wed, 11 Mar 2026 14:57:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: migrate: transfer large_rmappable flag in
 folio_migrate_flags()
To: Zi Yan <ziy@nvidia.com>
Cc: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 willy@infradead.org, linux-mm@kvack.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260311132342.3193160-1-usama.arif@linux.dev>
 <46edc7f1-f97e-4ff3-bf11-a56feb8e33b4@kernel.org>
 <1DA53E52-795E-4057-81F5-E39B85D7CF05@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1DA53E52-795E-4057-81F5-E39B85D7CF05@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pe7bbht8cenyuqfer5g9xt9b673uia8q
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: AA1241C0011
X-HE-Tag: 1773237441-508203
X-HE-Meta: U2FsdGVkX18pCou2yE0CHugueVb0NpffXE4Cm4ohI2bmkCp9DnDX/G51s9Iy1iVMG6hUtYSlbqEdIUR6QZBlHMykYjfwyRQph3DhQ7CnfSaslTBkeUIXAlV6TkcIp5NmaAzU8zpcBfClxid/NHnO8S2PgCzK3Qan6PhOInsPlLonR7825O0HDxdXsGudYx5KrXBWW2ORA9KmuItnkfI1DjavSDf8jjlvQjrzoCWLYavKPnjGqIKhYQSfYNF/gTsyNV/2OQRyNKtFojFJP3IWsRAMJUz1cxmco707Bjz/0s5Ko785CiSAFQ2ntKkgrz1nNZrOPbPlZXJ+Oddcc7RU/N5Cf+ehD8pGV2KRjruc63a+RDovqH3h2odEeEHglnAGcYUZdPOQrXyMv+CvvlpUKj51wRO86YeXxOXc4MuFEJUwsF/M6R0WwsrafLqiskgPR4S9hpt/12HdsAWDLHQ6nbKiLQhwl0r2FKwJOyU8Vb7MmdU3JZysrHJ8He5ZNLAnm1Bqj6s+bmq2qU7CbVHrXtJ8QQg6+xjkJIK7jtTXEZ9W33DqafDl6M4wVCPH4jjNVmaGdUH8eljqaFtF01naZHu9X4IYt1BlHpJNB+FB8swu9IEQCZyX4l1YNInPWAE2NZNquqPEtzeIuVFoFI+FzRUyGdcER5Z3pl3xXMIci04MA4fd6J4GjRIl4+dhCh2HSmgEY1/OpHV1JhA5cPqb5vIK5xHXrwJ7yzovRp78+lxxFB/C9JYw8ugXNp15Br0q9j5a0qyuSlk7yvtBSnQeYylrpYexUzxljAM7TZN/BjIuUWJpQr3k1bXfL2eHC3P6ZPe37+NTVd4FMpmkVR/MNNYidy25osr3HHKyxTRkBrdWjkTbxxam+GRJe18Sk1hZBP5Y2YdLvcRSs+9m/UcWym4nWl+Z7Sli8xk8IEmGLFUqnBurRj44JaW+8wGvXQzxfXObxgQpgLUq27NpaKE
 MvOFEkl7
 gQOgC4175xHtpvSwKq7At9m2OLPEwxilXPCWzZs2ymKgw2yJEXhH8KlzTxQJO+tMyfFKg0JlInA3IiF9PtMbS07ssXTY/7YgTge3fVJxUM+/HIkxL5RJlxuh+56JHQLmUgYn2VJQveZ+UDqraREMcwy1HixyUnsjucq2g4w2VNy9efOiEc+JIQuaivYbU+d3zBePphMeNXQm7BkDzb8n/p26rQUOIQdzRH7W67D2ML6PtAKCSgLVM96zM9jcHhthTGAkbXPL6hUrhNFC/np502iIrppn4tx5KpbDQVmOHwgrIEwQC/8yayajtuT2SvHqIz+Ki0g03EMVazy1rud1M/d0nRUJRW/czylH6hmRvIQVzzAmK/x2PDx4KnlqT3qdWbf5X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/11/26 14:38, Zi Yan wrote:
> On 11 Mar 2026, at 9:33, David Hildenbrand (Arm) wrote:
> 
>> On 3/11/26 14:23, Usama Arif wrote:
>>> folio_migrate_flags() transfers folio state from source to destination
>>> during migration, but does not transfer the large_rmappable flag.
>>>
>>> Migration allocators like alloc_migration_target() and
>>> alloc_misplaced_dst_folio() use __folio_alloc() directly without
>>> wrapping the result in page_rmappable_folio(), so the destination folio
>>> never gets large_rmappable set.
>>>
>>> This becomes a problem when a folio on the deferred split queue is
>>> migrated: the destination folio can be added to the deferred split queue
>>> via deferred_split_folio() (which does not check large_rmappable), but
>>> when the folio is later freed, folio_unqueue_deferred_split() bails out
>>> early because large_rmappable is not set:
>>>
>>>   if (folio_order(folio) <= 1 || !folio_test_large_rmappable(folio))
>>>       return false;
>>>
>>> This leaves a stale entry on the deferred split queue, leading to
>>> use-after-free when the shrinker walks the list.
>>>
>>> Fix this by transferring large_rmappable in folio_migrate_flags(),
>>> consistent with how all other folio flags are handled.
>>>
>>> Fixes: dafff3f4c850 ("mm: split underused THPs")
>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>> ---
>>>  mm/migrate.c | 3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>> index 3380021fd3db..ee1c7bc851dd 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -846,6 +846,9 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>>>  	folio_copy_owner(newfolio, folio);
>>>  	pgalloc_tag_swap(newfolio, folio);
>>>
>>> +	if (folio_test_large_rmappable(folio))
>>> +		folio_set_large_rmappable(newfolio);
>>> +
>>>  	mem_cgroup_migrate(folio, newfolio);
>>>  }
>>>  EXPORT_SYMBOL(folio_migrate_flags);
>>
>> compaction_alloc_noprof() does the page_rmappable_folio() at the end.
>>
>> I'd assume that all migration allocation functions must take care of that.
>>
>> It's a responsibility of the folio allocation code, not folio migration
>> code.
> 
> I agree. The migration allocation function needs to give a folio or other
> types of page matching the original one. Do we want to turn this into
> a WARN to make sure newfolio matches folio's large_rmappable state?

VM_WARN, sounds reasonable.

-- 
Cheers,

David

