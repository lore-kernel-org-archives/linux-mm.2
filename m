Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78186C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:11:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85F3D6B0096; Thu, 27 Aug 2026 13:11:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836B26B0098; Thu, 27 Aug 2026 13:11:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74DB06B009E; Thu, 27 Aug 2026 13:11:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 460126B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:11:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D5ED91A014B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:11:54 +0000 (UTC)
X-FDA: 85147691748.14.1A3F391
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1740780004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:11:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lYMFXQSv;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787850713;
	b=UQZykzLWEeNvdWsDUd1WW51VeJKuPs4iVdJP8yrZnh1kfz4WZ5aVMimPQ3dQ9pkPQdSwrG
	5woaUEj4PnwPeCU6dRM64cMUSrSGCEi2KS5pDlBVInMymkb68moT+1yPoG9UP8GUM/yT/x
	5DoIhcuYYc2yJXwAtemgtJrumXgneKQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787850713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RC+J973SAcXYzaJ91LaXDV4phn83jHym1gNT+C92v1U=;
	b=5uibY3NUaP2/+RBu6VPZmSWUCX4Y3mbv8Mv0N+/x5hDIJ8ZVRwmqjIa3N+caL1v3p6w5dn
	VpIqpepKjT3DvPbXOAG+7xXieg8DEM+0uAu9bQkaevXk3YDdEgKmW/iwYgfIJPjlM8Tssv
	FEpxzrSUiIyfkZTnUyLQneBGLI7QHu0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lYMFXQSv;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E2B940789;
	Thu, 27 Aug 2026 17:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2DD1F000E9;
	Thu, 27 Aug 2026 17:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787850712;
	bh=RC+J973SAcXYzaJ91LaXDV4phn83jHym1gNT+C92v1U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lYMFXQSvDbWchSW5xmpB6eVYqqlP8eYiKnuzPWtU9NymdYwvQS94x1If5qq+1EYJ1
	 vYEOon0PHx6xyBBQEh3pETITRZkyEhNVIqqlP52TxOAgFBduJ2QouqyemTsCFUb8Ui
	 3K5DbHrit6x8VuGwxBFB0d153pM0bKPB40evpPBcyDJKZh9DDa1sUBze3K5//C37lI
	 YVcOloGj3qu4WB+nqROoSHLqDyhVPGDZ4pdZ2dIUSlIEisqK09w0Z4CzAlqLE38kei
	 iemmaIYK5DJytkuxo6Zsy/8iyOYS8phgw8DjOXVxcSEL9GHJtVRQmMGzohBdmXAN/c
	 ViK5A27oc2K3Q==
Message-ID: <6f828d1e-0c31-441c-acec-80dca98b03d9@kernel.org>
Date: Thu, 27 Aug 2026 19:11:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/18] mm/huge_memory: fix rejection of swap cache
 folios with a mapping
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: kasong@tencent.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-2-9b43f5163238@tencent.com>
 <50bb70bc-d442-43df-ab4f-a158c8b05ac7@kernel.org>
 <apBtGfatUUecH6Lo@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <apBtGfatUUecH6Lo@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1740780004
X-Stat-Signature: b39wy63eo96j97symt7pq1qeowop3hm8
X-HE-Tag: 1787850712-535319
X-HE-Meta: U2FsdGVkX1/1pdEGJdQlBEhOKlpGyCycA9I2PBGnJzMQgtFo+VgmrT5v9QVfkq5drJRzv47Dklm6oDDa1erbKoOpKOwJx76U9AuTcCJcocZ4ej1b5IGzuUDI4vIbevKurIX923QM20LpawJcGGkU+rgVeBYMFvBwIdSRCwJlv5JpEOsyoNxVA/NoVVvEVpqNqyeCNhIOINWYJ45dI3hALsknT89YpzK14KkoRltbWPYVcrD6MmP2/gGAn0vNn+I7zxYu0j+y9WYf9GjLqPOBWep6A54YczEB9haY53Mhh+IHgewu05fr2GfFoHk3uq/+Ve47PlcwY+xMZA05DdDMVaNLiYIAuNSaY/OlWhM/TWPyJ/1ekKZ+QC6DsSwg4ibtvl9XtkI+CTqJ3Mb5QypVCXhuW2HK8dzaNmM5O9UWuf8PGj2xuqNZt20/f2JOnbkK6Y7ZVySBEcL3lbYVvTrYXUyqRXLl1p1g/x2hWd2rEsUyTpBoHZMKINNBzeTv81MA3bI37JL1zbLMs1jmkskzcku9YUslfJw5JKXLmYK72s0oJV5Zknjq6u+8unfBSqf4602sidGpV7/Xl2rvrR3km67kSSKNMU8GH5LquLJ8naRre5jVrSprhn5m32VETlys+Tysfn4ks7zL24Llk54U1HETe/sMuRn1Y4zmlGivMaG6MbECc7fUH/bx0UUATvI3KIMJQu0LNDYnyNwzftux/nT6etPQovcbIUwC7My+VoEU+xuiVy4MUWINyDRmuvCx5+2LX3K6gsQpyWXWSr0P0iIqdNYiEycEUV0MAzdPPJ96wwQ1NDMY+QIxbEMIwfuFm6VzqpCYeOoKp/9Vl3gZ0nEaYRfeHUaVM3v8flzZSPg7yMuHSSm4AWk9hCXJnBwbleXJd6DyDgCkYcZ0A5DqwUjmiMMYa/UpVS75dMQ1r8HvGNHP+si/UoUCeHU7p7/0YVOmTaKrEYnVuQFwVr/
 nuY50LPp
 KXGejVEP67kCYH5SIZOv+4WlP2uyM9roMewey8nHSDbUGUIjWMRINxnKL0S+0jYyZ6PlWCzRe8+kgD0UNslHfP6hO6D8/CNkVxvjkf+ZYvATq1f0ysi8BB58suAoJBm7l0pyU2NmvZuXEf8Qbk78wUPVsPhFem9qR3bYa+azNqH4t4MRKo+nfNGihAyekuuGY0XBBwaVSWv49kIzwABmkYZyRB2VKgPAkuRykunu75d9Sa4sMacsR1Qy1m5ioNd1Kz+Ddf5gm0xp9/DOY34lofhlqW8yAZzCdZ5MCUitaNRD05+QNmn8xscP0yiDW6P8Ka3BLrD0GqAdDckgp2H64ps6v6fav+fT1WgS9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/26 19:02, Kiryl Shutsemau wrote:
> On Thu, Aug 27, 2026 at 06:00:33PM +0200, David Hildenbrand (Arm) wrote:
>> On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> A folio in the swap cache cannot be split if it has a mapping (shmem).
>>> The split code does a defensive check for this in
>>> __folio_freeze_and_split_unmapped, after the folio ref has been frozen
>>> and the NR_SHMEM_THPS/NR_FILE_THPS counters have been decremented. It
>>> rejects the split and returns -EINVAL without unfreezing the folio or
>>> restoring the counters. That error path is buggy: if it is ever taken,
>>> it leaves the folio frozen and stuck, skews the counters, and fires
>>> the VM_WARN_ON_ONCE_FOLIO for a state that is actually legitimate.
>>>
>>> Check for this case up front in folio_check_splittable and return
>>> -EBUSY before any state is modified, so the split routine always backs
>>> out cleanly.
>>>
>>> Also fix a bracket style issue that checkpatch.pl keeps complaining
>>> about.
>>>
>>> Fixes: 00527733d0dc ("mm/huge_memory: add two new (not yet used) functions for folio_split()")
>>> Fixes: 714b056c8321 ("mm/huge_memory: convert VM_BUG* to VM_WARN* in __folio_split")
>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> ---
>>>  mm/huge_memory.c | 27 ++++++++++++++++-----------
>>>  1 file changed, 16 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index ced400f72d43..a6759a14e057 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3878,6 +3878,9 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>>>  int folio_check_splittable(struct folio *folio, unsigned int new_order,
>>>  			   enum split_type split_type)
>>>  {
>>> +	bool is_anon = folio_test_anon(folio);
>>> +	bool is_swapcache = folio_test_swapcache(folio);
>>
>> Both const please.
> 
> I see a lot of const everywhere in mm code now. I feel I missed the memo.
> Do they make a difference? 

You tell the compiler that you expect this not not be an ordinary variable but
instead ... a constant.

Any future code changes that would try to modify this variable will get a
friendly greeting from the compiler stating that someone assumes this value to
never change.

The compiler can't do that for you if you don't tell it about what you consider
constant.

-- 
Cheers,

David

