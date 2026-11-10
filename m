Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41D1D606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=odd4hU8r
Received: by kanga.kvack.org (Postfix)
	id 5D9816B05B1; Tue, 10 Nov 2026 15:55:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B1666B05B2; Tue, 10 Nov 2026 15:55:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C6756B05B7; Tue, 10 Nov 2026 15:55:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 284816B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:55:49 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B3AA2140113
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:55:48 +0000 (UTC)
X-FDA: 85420415976.04.298A3A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id C8EB6180006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:55:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=odd4hU8r;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794344147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nwv4Mn7/SQG478DoXic1rvo4iDc2CU3fpcIs3PGWYcw=;
	b=sNRDYcgbtRfugNWgYtRY4xPtaa00V2VGkGYbPCWX+l2iL6YmExz0vZAMEcX5kbu1giIr3i
	LI4KB9qt432KyCaJWyUoGnbteQ4jwAxuAc7jIRcKiQ/ewPmy09GPMhlNJytFOZnNTuqW0k
	fF7xQPEY3TiCXzQ75en77y0GpZd7VEk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794344147;
	b=JlVVdhmCnXT5Jk8cmDVHwCA+prQ2PY5Bk0e8C0xML6a6EGk1F4xIMniUYDaE4tt1Q2zNio
	smQhm7nT7w2xKyK/UnLiKg7N1QtwBkL39Ltb3jsurFxyGeqJPmX2VdJ+/zlqoUwtWH674D
	UfvXIXgEW2RQaOfnaWxs3UVvErpOZRY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=odd4hU8r;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EDF7A4182A;
	Tue, 10 Nov 2026 20:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A581F0089F;
	Tue, 10 Nov 2026 20:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794344145;
	bh=Nwv4Mn7/SQG478DoXic1rvo4iDc2CU3fpcIs3PGWYcw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=odd4hU8rQTSunN0wqawB+FqVMOAFyPTtLWmAZNvlBKB6UFayCR01mClp9U4XSHtXY
	 EOEuhlWRC/QvA0X9iPq/ni9b6IaS1vAddwUlRKNpLovXPcjAUYtE7zbB2V6132fZF5
	 vdXmyOA/g8V1PrwZ6uaJueaJy+mvPIKL5pZ9MSUDDW1nTuyUIXK7u+bTAjDQL5YEiO
	 6Omvonz/gIfA4izDToV22vJm6LYMjhU71CQaELV2OFHnX1mP4NfPGtEa/YXbY7dunE
	 QBRmb0vkeN7L2ZAdyrQdi/YfD/qluqwn7Tr2ysP8lNdUThKyrB7S+Qe5OMhNvqsoT+
	 RnZBfNSaQkziw==
Message-ID: <520a5027-8c46-4111-b6f5-44ee15c1a267@kernel.org>
Date: Tue, 10 Nov 2026 21:55:35 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/rmap: fix migration entries being treated as
 partial unmaps
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Kiryl Shutsemau <kas@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Zi Yan <ziy@nvidia.com>,
 SJ Park <sj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, Sashiko <sashiko-bot@kernel.org>
References: <20261109220958.2071687-1-joannelkoong@gmail.com>
 <07a8ffc3-1f71-4e41-aa83-424e267ee48f@kernel.org>
 <CAJnrk1Zn4xvO2ySmmgk3vqXUKwz5TPHMWtRdKgma8icWsug9Vw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJnrk1Zn4xvO2ySmmgk3vqXUKwz5TPHMWtRdKgma8icWsug9Vw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: yzeqdcfxb3xf79dcxc64kdk6fh6sjt1g
X-Rspamd-Queue-Id: C8EB6180006
X-Rspam-User: 
X-HE-Tag: 1794344146-573499
X-HE-Meta: U2FsdGVkX1+3eEKXwko1DAsl7J1G+N8smYa73m/4uTf8v1aSsoyefDhdOCy+E2JwIX87Wu4FkeVLk6pQK1nhmSiqXG0Kx8D26YcMiiKfBaliM389tzC46bWQ33YYaT11jRVJ6bIVVhlNf2g140fSS8x+QkMZTSBbPHoFzTD1Wfwp+2OJ8QLlyoL03tLesTGC+S7pjEPROeZWV7M9c4ziP8pmDb6zPD2NvaPHhbr1d16n1hcmVKUltwBG+WbwFSaOSmPIOyXjQPeouW1l3KQnecvIPjiOXhX0vexyRN+/zh7/fCd3LjWq5DvOq2SCCbuC7mvP1hZyvglLrE0EqQsqCPYs/6oF7Laq3HeehzjLYbV94eXg3ukdgFAMvY8xePhTy5r6sHB9ekwpm7SFZb8hBqLQ3RQBwsFJsEcEhgB/TE5/tB0JJDbzu0Dkv/5vjfnj2GLcaaTQI6kA89ImhtsZbjGjm9AO7DCLqt5VS5oafOC2Z0r9Ob9rstSad33i1f6D9QJZitx4IdRF4rmsqfU+iROY+weK/GsgCrcrBkmdk827cUwBRCa7iW7C93irnP2D4cPEnCqVsi0WI9/LuijAa5xRs6rM5MrGJcUFXuFEvIxdJ1bmXvUJPbR8gqkQJCuJ6+kZ7rdvsXvOnCLA1ov1ic637wEJwTdn6Xd5qJNAfb6TT0DWw+S9Pwwl9jXO24GB+MEzAKppKZJ2jOzPm8EmrIyY57HHf8jwhddX6ER/8Et6YivvpkippwTZJlnsls/gM+9jo4OWgByvfl7oCNvPJ96agVtFXdLF7sujuMMomEtzXDyYuZYQhSTqNRJdeF7mw8fmtJZH7hP1I+4D78ktoNO8UM7PMhg5UJ5oShNK/i41oFcUKxFURVrCjNGNiHjB8zY0SvF02umJbGCXkBWPZSuCDdv+KZObRx2wgc3RUudVG9tFgPMqig68utC+guAYW8Nz9arj/9a02vOanXs
 0BRdXFYH
 xkJmnL0z3vdLZS8ZPL4sJRrTrf0JWu6BOjusQyBqdbZel2eN3uwV5UAUN96iIuFhBeGSvmBLflg51AoGFprZm2Q7qOL+PNg97yIWZSMQZ6kFHcKAYebURHLgEIf5FTk5EwLvhPgNnUQmheK5KekYN9r13mLoobUkLQgguOQ8YVi5Q9pF/Y9ty//FOlokqRrFLSi6BgR12h3mH9dWRYqZS0a1uHENPFWVNl5l3VDmB98KEJ8fAoABgDU5P3J5D9zIUVDPVkIhBMP5othovmBAt5KtCCS8VFD7pcxaeY/1LPOHnyYXDzfdamJDJLCl1w4d6I2raNn+1M9NlZ/iuwT8Wf+TR+3+DXMl88xqUcVHzX89EYtNKb5cam59pgNOCHUjHY0Ai2OI1kJHESE0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 21:21, Joanne Koong wrote:
> On Tue, Nov 10, 2026 at 3:49 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
> 
> Hi David,
> 
> Thanks for reviewing this.
> 
>>>  - A folio whose split fails can later be split for no reason. If the
>>>    split fails at folio_ref_freeze(), the folio is remapped but stays on
>>>    the deferred split queue marked partially mapped. The deferred split
>>>    shrinker then splits it without checking whether it is underused,
>>>    breaking up a folio that is fully mapped and possibly fully in use.
>>
>> This is a similar problem I raised in last year's LSF/MM:
>>
>> https://share.daveh.de/s/bQsDpD7xigJ6wD8/download?path=&files=LSF_MM%2726_+Deferred_folio_splitting.pdf
> 
> Awesome, I'll make sure to add in a link to this presentation in the
> cover letter of v2.
> 
>>
>> "
>> 2. THPs erroneously detected as partially-mapped
>>  * Failing migration/split/eviction after stepwise unmap
>>  * Remapping the folio will not fix this up
>> "
>>
>> The news here is that we now copy the state to the new folio and can
>> consequently split the new folio.
>>
>>
>>>
>>> Mappings replaced by migration entries are not really unmapped, so don't
>>> queue the folio for deferred split when try_to_migrate_one() installs a
>>> migration entry. Pass a flag down to __folio_remove_rmap() and have
>>> try_to_migrate_one() clear it for those PTEs only. PTEs that it replaces
>>> with a hwpoison entry or discards because they are unused are really
>>> unmapped and keep the current behaviour, as do all other callers.
>>>
>>> One consequence is that if part of the folio is really unmapped while the
>>> migration entries are in place, zapping the migration entries does not go
>>> through the rmap, so the folio is not marked partially mapped afterwards.
>>> For a split this does not matter, as the folio is split anyway. For a
>>> migrated folio it means the destination is not queued until a later unmap
>>> notices it, which seems preferable to queueing every migrated folio.
>>>
>>> Fixes: 8422acdc97ed ("mm: introduce a pageflag for partially mapped folios")
>>> Fixes: a2e0c0668a34 ("mm: migrate: requeue destination folio on deferred split queue")
>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>>> Closes: https://lore.kernel.org/all/sashiko-outbox-198104@kernel.org/
>>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>>> ---
>>> This bug was found by Sashiko in its review of the mTHP shrinker series
>>> (https://lore.kernel.org/linux-mm/sashiko-outbox-198104@kernel.org/). The
>>> migration / rmap code is still new to me. This patch is a fix with the help of
>>> AI, so I'd appreciate a careful look from people who know this code better.
>>
>> Don't we have the same problem for try_to_unmap() in some remaining cases?
>>
>> See below.
>>
>>>
>>> This was tested in an x86 QEMU guest with 64K mTHP. Splitting 64 fully mapped
>>> folios through the split_huge_pages debugfs file no longer increases
>>> split_deferred (was +64), and migrating 64 to another node no longer leaves
>>> nr_anon_partially_mapped up (was +64). split_huge_page_test, migration, and
>>> khugepaged selftests pass.
>>>
>>>  mm/rmap.c | 29 +++++++++++++++++++++++------
>>>  1 file changed, 23 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index fa34e1ccbd8f..e5d17481c0c0 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -2772,12 +2781,20 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>> +                     /*
>>> +                      * The folio only looks partially unmapped while this PTE
>>> +                      * holds a migration entry, which is later turned back
>>> +                      * into a mapping. Don't queue it for deferred split.
>>> +                      */
>>> +                     may_defer_split = false;
>>>               }
>>>
>>>               if (unlikely(folio_test_hugetlb(folio)))
>>>                       hugetlb_remove_rmap(folio);
>>>               else
>>> -                     folio_remove_rmap_pte(folio, subpage, vma);
>>> +                     __folio_remove_rmap(folio, subpage, 1, vma,
>>> +                                         PGTABLE_LEVEL_PTE, may_defer_split);
>> We will not add such magical boolean parameters. I have a patch to just pass the
>> rmap flags for a different purpose.
>>
>> But the whole thing is rather ugly ...
>>
>>
>> You should probably look at
>>
>> commit 354dffd29575cdf13154e8fb787322354aa9efc4
>> Author: Barry Song <baohua@kernel.org>
>> Date:   Fri Feb 14 22:30:14 2025 +1300
>>
>>     mm: support batched unmap for lazyfree large folios during reclamation
>>
>>     Currently, the PTEs and rmap of a large folio are removed one at a time.
>>     This is not only slow but also causes the large folio to be unnecessarily
>>     added to deferred_split, which can lead to races between the
>>     deferred_split shrinker callback and memory reclamation.  This patch
>>     releases all PTEs and rmap entries in a batch.  Currently, it only handles
>>     lazyfree large folios.
>>
>> Batching resolves the problem in the common case. For the remaining parts, we
>> should likely just check in the deferred split handler whether actually
>> partially mapped to then clear the flag if not.
> 
> This sounds great. I'll look at Barry's commit and rework this patch
> to batch the unmap, and I'll add a patch for the check to cover the
> edge cases.

Take a look on the list, we might have already had some attempts to batch in
there (we just lacked the capacity to review them). But maybe I am daydreaming :)

-- 
Cheers,

David

