Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08113606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jsFIg8OW
Received: by kanga.kvack.org (Postfix)
	id 2CCF76B00EF; Tue, 10 Nov 2026 06:31:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27D006B05C9; Tue, 10 Nov 2026 06:31:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16CBC6B05CA; Tue, 10 Nov 2026 06:31:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E29D26B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:31:32 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 780CB160559
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:31:32 +0000 (UTC)
X-FDA: 85418994024.08.B42183E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id B858B80004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:31:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jsFIg8OW;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794310290;
	b=ltCQw0Tx6L2UcfpRk18bekUe3Lf8TXsqQ++WDPKJAgN1DZ397RiQllDs5UA2eVBNjqJHse
	iAxXXtC6RI25r6VrumRakSBxEyagt2o+HS49SboC37IO47cBs7iNE80nJRA6yIxbbek/4r
	/4xqpAIpEfHwVkYcdrFvMxcBSqmD66c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jsFIg8OW;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794310290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C0n3nQ0/EkPhfIZ0bOLKgEtCzma4TypL5QzeO1dwihU=;
	b=kPThc5D/m63yKYTiRg79P0ZLit+s/aFdgJx1chWEyy4V6nINymj7EmIDhlNGmEVJiPPJmM
	IQMnO2yp9i1yRjm7P6lYVxPyQH17Ualfn+S8GdbClsmMczg0dtq1U40FUr7CpTB3JvznT+
	4W310C/fnJ0D7riqYDfy3RZc5MbjY0U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E47C661819;
	Tue, 10 Nov 2026 11:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8671F0089F;
	Tue, 10 Nov 2026 11:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794310289;
	bh=C0n3nQ0/EkPhfIZ0bOLKgEtCzma4TypL5QzeO1dwihU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jsFIg8OWxyx/Zjto9ZQGcoA58L6P6CQ+P3y+vc7P7OA8YIKFLi2TRBxUvhUZY1C+1
	 bpVQL2GKJe1PovLcBfSjY+3XgGXJ/Qqa1CTvTBCfWXasirIL/R3smnCBVfsxYLrK5s
	 cJT0QtEmWt3nDNk9YqQrR3t8cPwVeKnkk9upNaX+dAW9z/DSsjHzCgxhsVPoH5NHp1
	 tj27C2o9Hd3G2/D9WeKKor1V+uzoQuvkr9z9cemEeGJVOog2biBAuDcOlK6E5DGYfa
	 +ndhHfyEPstIa3PSPEyKd5XRZ2jT1dr8+X6eDxvFESfanmdIvBcYUBNltYKO3189r8
	 06KFhoQNaQTKA==
Message-ID: <a3557629-d86d-42f6-b181-bf8540dc1982@kernel.org>
Date: Tue, 10 Nov 2026 12:31:21 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/huge_memory: prevent losing PG_waiters in
 __split_folio_to_order()
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Brendan Jackman
 <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Ye Liu <ye.liu@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261109-fix-split_folio_to_order-race-v3-1-1cdc509e34be@nvidia.com>
 <5a7bb477-5392-404c-a748-4748cec2c84f@kernel.org>
 <940CBBBB-D564-4D4F-9C8A-A9A272F08064@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <940CBBBB-D564-4D4F-9C8A-A9A272F08064@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: shceaq596ampe4nh1ysq616jpj3txt66
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B858B80004
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794310290-763982
X-HE-Meta: U2FsdGVkX1+jzb7iSPdf6Rr4Sa3mhd8fbRN7H2jDNgCfVC75zYwPdBHcgmVh/7zO/8Kaad73iHs814r83CDPpyRTjp0ReOhZz3OBCPya3H0l6ZbzFF+lVqfTkgQ5GN7jxndB0xgfGt7DVPuVwpNaWET05mZh9vcZmHrTV59FtNoFAb6leON0RFhoeY1zB05ciWUSyAO5ac3mOr/R1elBfiTdpALaqkBlQthWKlmpzQsEqECeIeoRc1EbPHbChLuAouKaCsbMnRlC8p6w7bsrHMcwMI+nuxPB/T9un8hkbCt/c9LztcWDrPQiiF4D+hkCHtFmcs/xPGcmc3hMhjZNSFjW6Dhbqzhajk7JxRoEfDRgXEWBO+KfuW9gdLH3mTtP8Yh6EQElhyTMPhvMmIQWeQOHMl8VU78EmlRcHL9U8zAS8P+cDD7KaCChhCcOSCIRv4OTQ1F6b0W5F8QTm6i39FVKclgyy6m586TqMG0ZY0SObWJECjJibTLnLiy7CNu5/1rsM4rWAuJ4ldsVpnGemDHihYDIHR5pzW0T3jeTN7uey5NovL4SKu2AUZPA71Ev5wMzjC/cPd9wcyn4HghOATZMrFYjQd9GRv6MZdGk8xNvlzp/nL4tOwWxJLYcZTRiUnR3TqlX/VYFIOzOqW0fCNIBfAUTWbMtvhgf/1JgiiUyl8gXDQQQxyOzx/KfGFPp0H0DtYcgDrJNJa9hV/iS7oForcz2ierJoQ31jKP9IlGppyYE1uibARqex5WP1Z7BnL9XgamQTxwGdxjTIpiHWGGLd3Qgma6oL8BSkP68JWil1Qb5HlA9U6SBLcpN2O4UZlNz7NBAxa+0cYxcvYwbF/fVNPBFwew5z23XbCSRpYIJHXoux/UmJFN9PiRaTZj97IzQQibVKCW7vJPzElxt+Kk4BSmktCbuXxtURGCvsFpFBXG5BGWIQkeV3bYPZCCFqF80YBeLtr/Rxodu/kV
 vhQjXWw0
 0aeGEKKt0Mjgs4gWa0j+kWuadY2+tS65CzQwPW1JdFLS3thvIl7+3r//uE/yG+57LfQ7Yk7sDuGov25wjPUDrDwvew+jFxSXIMQKU/c/39a8x3Mp3eBqVWTbJX599+iBj0bgv6LqM6/elEX7r5PjSSiXRLomZT5rMBXt2xb0LrdW78H9PdghnrSjoJl1Zs991KzwcYDPpoZxEHFZHcrSg4RckJmMhV7cB5fT5jr8vZDc4yVjZdXoXEQvMxc80HBK3DxAvdQrIBkNuZp0ErKHZORb8QkwL0Z+9iBKbS0glO5zfiCiBHrUv+Rw9Fpy104z5HvakFFpM22cU0HpPhcwWxEOl5qMnnWS5q9bS+/vfEzRpDMgvW3phdCt7Sf1EG6a92LyZRYtHlJfaYuQUlUf8ZL12sSZvnTbz5kt+UJBxZnvpESgtveu2Ip9xxxzkDzPfQ6R/RK600+z26Oj3QoXF2QhbDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 22:05, Zi Yan wrote:
> On 9 Nov 2026, at 15:21, David Hildenbrand (Arm) wrote:
> 
>> On 11/9/26 20:32, Zi Yan wrote:
>>> __split_folio_to_order() calls prep_compound_page() on each new head page
>>> to create a compound page after clear_compound_head(). prep_compound_page()
>>> uses non atomic __SetPageHead(). It is mostly OK, since the folio is locked
>>> and frozen and no one else is supposed to modify the folio's flags.
>>>
>>> However, code calling migration_entry_wait() can reach the folio by PFN,
>>> then access its flags. It is because softleaf_entry_wait_on_locked() used
>>> by migration_entry_wait() sets PG_waiters concurrently without taking a
>>> reference and the frozen refcount during split cannot block it. Meanwhile,
>>> __SetPageHead() does a plain read and write, so PG_waiters atomically set
>>> by softleaf_entry_wait_on_locked() will be lost if the set happens after
>>> __SetPageHead()'s read and before its write.
>>>
>>> One example code interleaving:
>>>
>>> CPU0: __split_folio_to_order(new_order>0)  CPU1: do_swap_page()
>>>
>>> 1. clear_compound_head(new_head)
>>>    new_head->compound_info = 0
>>>    (page_folio(new_head) == new_head now)
>>>
>>>                                            2. migration_entry_wait()
>>>                                              softleaf_to_folio(entry)
>>>                                              page_folio() -> new_head
>>>                                              (not the old head any more)
>>>
>>> 3. prep_compound_page(new_head, new_order)
>>>      __SetPageHead(new_head)
>>>        tmp = new_head->flags.f  <-- load; PG_waiters == 0 in tmp
>>>
>>>                                            4. folio_set_waiters(new_head)
>>>                                              set_bit(PG_waiters, &flags.f)
>>>                                              enqueue on waitqueue, sleep
>>>
>>> 5.     new_head->flags.f = tmp | (1UL << PG_head)
>>>        <-- store; overwrites step 4, PG_waiters == 0 again
>>>
>>> Later, folio_unlock(new_folio) sees no PG_waiters, skips folio_wake_bit(),
>>> and CPU1 can remain blocked indefinitely.
>>>
>>> Fix it by setting PG_head along with other flags in new_folio->flags before
>>> smp_wmb() and clear_compound_head(). The remaining compound page metadata
>>> is set after clear_compound_head(). In that way, after
>>> clear_compound_head() makes new_folio visible, nothing overwrites the
>>> PG_waiters from softleaf_entry_wait_on_locked() by modifying
>>> new_folio->flags non-atomically.
>>>
>>> While at it, use data_race() to suppress the KCSAN issue reported by Ye
>>> Liu's patch (the second Closes) on reading ->flags during a folio split.
>>>
>>> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
>>> Reported-by: David Hildenbrand <david@kernel.org>
>>> Closes: https://lore.kernel.org/all/DMHE8BEEER1H.2BIY52NXATPIA@nvidia.com/
>>> Reported-by: Ye Liu <ye.liu@linux.dev>
>>> Closes: https://lore.kernel.org/all/20261029-data_race_huge_mem-v1-1-112e331291c1@linux.dev/
>>> Fixes: c010d47f107f6 ("mm: thp: split huge page to any lower order pages")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>> The issue was raised by David when reviewing Ye Liu's "mm/huge_memory: use
>>> READ_ONCE() when cloning folio flags during split" [1]. This patch also
>>> supersedes Ye Liu's patch.
>>>
>>> [1] https://lore.kernel.org/all/20261029-data_race_huge_mem-v1-1-112e331291c1@linux.dev/
>>> ---
>>> Changes in v3:
>>> - set PG_head before smp_wmb() like Kiryl suggested instead of
>>>   prep_compound_page_atomic().
>>> - used data_race() to suppress KCSAN reports while at it.
>>> - dropped Lorenzo's ack, since the patch is changed.
>>> - Link to v2: https://patch.msgid.link/20261106-fix-split_folio_to_order-race-v2-1-1b59c67b8af3@nvidia.com
>>>
>>> Changes in v2:
>>> - renamed __prep_compound_head_and_tail() to __prep_compound_page().
>>> - added comments to prep_compound_page() and __prep_compound_page().
>>> - Link to v1: https://patch.msgid.link/20261029-fix-split_folio_to_order-race-v1-1-a483c7451b0d@nvidia.com
>>> ---
>>>  mm/huge_memory.c | 32 ++++++++++++++++++++++++++++----
>>>  mm/internal.h    |  2 ++
>>>  mm/page_alloc.c  | 17 +++++++++++++++--
>>>  3 files changed, 45 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index bd44d58e86845..99b48d7c988db 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3714,6 +3714,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>>>  		 * Don't pass it around before clear_compound_head().
>>>  		 */
>>>  		struct folio *new_folio = (struct folio *)new_head;
>>> +		memdesc_flags_t new_flags;
>>>
>>>  		VM_BUG_ON_PAGE(atomic_read(&new_folio->_mapcount) != -1, new_head);
>>>
>>> @@ -3730,8 +3731,16 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>>>  		 * unreferenced sub-pages of an anonymous THP: we can simply drop
>>>  		 * PG_anon_exclusive (-> PG_mappedtodisk) for these here.
>>>  		 */
>>> -		new_folio->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
>>> -		new_folio->flags.f |= (folio->flags.f &
>>> +		/*
>>> +		 * ->flags are stable since the folio is locked and frozen.
>>> +		 * data_race() is used because reference-less writers,
>>> +		 * 1. PG_waiters from softleaf_entry_wait_on_locked() and
>>
>> Hm? I thought that case would be handled by your patch? How can they still write
>> to the page?
> 
> This is V3 of the patch. Instead of using prep_compound_page_atomic(),
> PG_head is written before clear_compound_page(), after which new_head
> is visible to the reference-less writers.

I'm confused, how is it then valid to have PG_waiters set concurrently while we
read new_folio->flags.f? Because that's what your comment states.

> 
>>
>>> +		 * 2. PG_hwpoison from memory_failure(),
>>> +		 * can still write to it.
>>
>> We lose PG_hwpoison left and right when racing with non-atomic updates. It needs
>> a fundamental fix. Is this really something we should take care of in this series?
> 
> IMHO, memory_failure()’s reference-less access violates the frozen
> page contract and should be fixed. 

Exactly.

> But I do not think it needs to go
> along with this patch. We discussed HWPoison flag race with
> Michael S. Tsirkin and Miaohe before [1]:
> 
> 1. Miaohe proposed to reset HWPoison in memory_failure() as a best effort,
> 2. mst used RCU for all non-atomic flag accesses,
> 3. you also proposed to move HWPoison out of ->flags.
> 
> So memory_failure() needs a separate and proper fix series after
> we decide the right solution.
> 

Vlasta raised the idea to set hwpoison only after we actually managed to
isolate/grab the page. Which might be the proper fix.

So if avoidable, let's not add the data_race() here to silence something that
needs an actual proper fix.

-- 
Cheers,

David

