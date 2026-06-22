Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89794CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 13:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6999B6B008C; Mon, 22 Jun 2026 09:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A4F6B0092; Mon, 22 Jun 2026 09:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 511846B0093; Mon, 22 Jun 2026 09:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 260A76B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:43:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9ADE712015B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:43:36 +0000 (UTC)
X-FDA: 84907666032.05.5A943AF
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id 96C24140002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:43:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GVyVP2Xb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782135814;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gapKFppUXnPp8khihX/tbiyvBsky81sBAkI/bVrBroQ=;
	b=8KVp9N+HRh+j91/ZDUhWpJ66N45MDR2KxUwY7slvJOopelQlb+vznTygiQI6yb3MKnVFg0
	EzH2hxMR41A7n24CsDrY4s1V4eCa/ClVnWge1SNa/zruuM+SNE1bdldB1VX7NiWU8HezIA
	pJddjsclgNIZmKK6sJWw05iL2nhGSuY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GVyVP2Xb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782135814;
	b=R/2nk44KB4I+sUluAph5wKNPIiIaSG0NghCYF60gKm1z2jaH+P0hHGQYInIsHG+2sk/sRr
	Kc7356P70RVn4Iy6m0DnqvMCLshWTggp/j2OpuQTvsgJpFmvboJ7/ohp3fQzcmAZIdhkEW
	0NebqQX/7Y71QSwgaPz8ZEf3DrGUGb0=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-bebb72b845aso713015566b.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 06:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782135813; x=1782740613; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gapKFppUXnPp8khihX/tbiyvBsky81sBAkI/bVrBroQ=;
        b=GVyVP2XbPVoWF6oDXIzdeKz0wV6BhCy/hF41EaIZXNUJrQ0prjB0zDwnNtcYojXNSg
         aT+oELSj5bNPn1HKMsDJ05PcApGn7v53OxAyhwUvJF11IOnCBRudFqqIs0OTLXdrNrAh
         xrmKAgWrgy1tW6ODPjcGQmgfWEkUFFJrskrhDc1K2SsmbZGwStqL0NYpFtLYImGXIKR3
         FMkTgVKU8vPeAS271vxBfsbjQ2aym+l/KWUvemMgjn6X8Emk5lgVGFdOc17c4HbGQ0d/
         e6XIFqDqJm0U0cG6dzsGg1cmx/q1WfoY4Txp38Nf4yQPqtrAmBGvvKQNMgIt69h3psMA
         ywYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782135813; x=1782740613;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gapKFppUXnPp8khihX/tbiyvBsky81sBAkI/bVrBroQ=;
        b=INKBlZvckY93ZsnN7VYIACEp5MrdKR8N4o6RJpJqC+q/WJJY3XL3L9C+GtKOxteKte
         0QxKhbsiUc4hJjad0pNRW63y2XaKrACxdqoSF5wMCmEMa1mAXlwnTyiymW6GRZal8MUA
         afKtFQYpySIrtSDGQYZQ2KilOJHS7aWAh5NjDAg534fs1TRyegxuMLaJ6eS+T/qw9cNG
         B+QCT5hfTWAI6KpZmy7VGXgqulTaiFFcUqpvDNqlv6Sa/9WGUsmIlpHTtnrgY1w1EOzo
         Fa/lJzwv16Z39amOBcQMyYxmcgMEAxsqBq0LVe42723jCOp8GS64e8R2uRc0ASGjwGZ2
         O1HA==
X-Forwarded-Encrypted: i=1; AFNElJ8/IW3K1moZhNuvcmPKuwTF6Z7vLHwlNMJpzaH184B+VVniL7xU3tveWlN+yqEKrWh6Xnz5Y/eBAQ==@kvack.org
X-Gm-Message-State: AOJu0Yx3MVqVoUsb3KZmxop1AXQfrTKcDxWpdTmMSk+STFA6CMk80SxU
	Lxo7s2neVYJNoAz2NhPsVW7irKu+9OXloCqBm2bLfWS3Nj5dJf28bw4V
X-Gm-Gg: AfdE7cmjilHqWNFZo6VJlpUpT16CazmzuO109uO9ECx6dmcMc2KgArwD4ER907MB3ea
	fGWy2dduirZYfbZXl1CbBYl3WUOTXCyf04fzlWEYcI2I698of6/3sJX23WCTCtKijOm+pA5G6Ch
	TBqumA1SBd3IcZr920BseNXADz4BlD7s2MT4hkumCb+97XXl6fG62sielyJ2rOvZJtZpF2DsDjV
	3K71rzMENJAdybuCFzdJNXn7VvC7COb+4Y/xG5mziZ9dhiqJjuP2Dt8OPQnJMCRUrKAaMAfEdCU
	g8nIrOvEq/pio+YoaLbYfBStP0epu8rlNj1jnXBaIUI+Z3lF9+eXUB1phhfK0+Ju2z3PncbwAne
	3fcrgBd04y0EPW6xUb1qEl2kg9mXdtcoaO/f/He7zIio5LgfdWOuxaYnlz+ZlvoJW4YUrbbp0D6
	Hzh6Mvwlauyyo=
X-Received: by 2002:a17:907:60cc:b0:c0d:5466:ce4c with SMTP id a640c23a62f3a-c0d5466d9dcmr453345266b.1.1782135812718;
        Mon, 22 Jun 2026 06:43:32 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0c5e497fc3sm363612366b.8.2026.06.22.06.43.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Jun 2026 06:43:32 -0700 (PDT)
Date: Mon, 22 Jun 2026 13:43:31 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
	ziy@nvidia.com, willy@infradead.org, linux-mm@kvack.org,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	hannes@cmpxchg.org, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2] mm: migrate: requeue destination folio on deferred
 split queue
Message-ID: <20260622134331.xvbpu6edwml65myp@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260310105419.3256755-1-usama.arif@linux.dev>
 <20260620072721.x4dfh6gy4wnjqre4@master>
 <f820a74a-ee28-4888-a5ac-e1c4de8c0202@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f820a74a-ee28-4888-a5ac-e1c4de8c0202@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 96C24140002
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 9dwkr1brprthqfdwhia3bnftmprggwix
X-HE-Tag: 1782135814-416054
X-HE-Meta: U2FsdGVkX1/YuS8y9ZYva4SwsqTYg0vUZkVSITEZpWQ765njrWJWUiCEaXIj5QC8WKZU3hj4/YWQDXirv5AZm/5yfL51B3eJ9XPlTHWi+jBk88wMMoC6ehSQqJJ/QrTY51rrTVrz5gQnbhcwvv98FAyCeIGrYoBCH1MLQMB+MFV3fACfb12UW97eV9kEx1Rsz4uzc9xYvEb45ml7RZnSVRzOOqWH4jhVHGv3TozA0MiF6l2Wjfz5qOIdMvKK/96pPgfhOa5oMst9Drmd7JqsnzvN/htUgzQEt8RObws8DOMdLHMj2YVYKsBMu1mavoAErP+zsrDY8cyT/qbzUKOg/HhLC3+9c8ASKYv0uYw92z1V2BQrQrGxMD/zgRp05SD6lnCC3RPxGolym0LTFP3fkyzdlmJDucE73J1I5cjEsOY7eMzaTd6GOXPHc29kOSWo59fRAW+VsHZdSXtNmZJd1wE9jZpAbOqei02lCLKg4ZE4aaL8Mja2UG4XvWdSMi2JUj287eac1XhzG/0LMDAf+shf0kPqjjeWdKG5X5kKV4e2UdnUyhXM8wzpN9LW/M9OJx1j8+xTxunJ7qs5sAdbIxYf7aj5B+BudGbejyHdHemi71g3kBVytYomnhUYjqYH+GMkLk3wJB0J6OpWyQwDxkYKLNevxm9qdXCbZlq9HNmtdjUGzRZiY8dBx6HViknnFK8QrppGNmkWxTGIKBCdMKxaedvzY2H2FXpnySuuCNMoUr6sJUriBsIbDuEkGycR0M81JMR++EDgEahlgUoqITk19t3snTT+m83P85BeV8U1ZicPBxKWdR45jW8jYorvO21hJ0Rz1zmlWDeC/Qq+i+Pzf0gdOGiUVG8pVNOMY9J4nB2S4HLuWiMlHkw63K1rU+49io2y3USvoQUNexitQkZkweRYwowKFI3X9HGnxAZBwjPKs/7E8TItNVaklM4YxObdpoeVrfcZtxvxsQF
 wyWSeHPm
 GheEVyLmayXatpqzq0llx/J7sfj94CKYK9MKefvsKln7rlU174a+/sXkO9XMq/tW+oYTA5ROB8xmBXmTOkzFDzAljyFmCZnAm2npYaSx9t5KSjfFAoItikPz/xaDPJjzi+Yo0Ud1rym08CKWjn9nCRKJqNbZUZ8MkhRsxbatdbXuk5DUhutKGIHemeILufg19ATUA24aMvvl+vgNqGwLQUML1iDVbxDKqNyO78TfiOcunirDPxZaEhgcz0428VfJrpoj1zgKPYszqCWbreKn3wSmUwkF9F4/b7o20/+T07LYXdRkrXUFFPgJgRm2GPHJX2iOlKuTv4qK3cw+Nl68B84qOv/spsUr5xw4Xif6c8wd2WGjUIRVRKvW3KEdtbOBkr2NfMqwp4SiMBMbEZvyb7rEKa0f1uJ41iIC/AOxO+BgAzARf378ir3hsYTaIWsrxRkPh2yI8pdxsfWEoZvjkV7ZNlIdGLski2SFB3+kwYuTzltueIDjVB0F3ncBwzrNORqGkbutgM+eNFmTBj0keY5Lj8eSKDZnd02jN6xBRWQg9SEoG1Nhh28AzEiqkWVG7LQ4Kgxxd6ZpGZWj2stdJMfLyhI90wtssqxNBTnpcPvWe9Yr46zBKUFYramXKhCNVKgY9DxsPj0qelmj7SrEDlZiHGU7LehijNY2C9L9hnkrvVVvHNQCPOHHf5sHN4GbnUo5Uey+3jRhrTZ5vnY+pwRhhJDiRMGB+b2++DFWxnFWQ5CI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 11:16:39AM +0200, David Hildenbrand (Arm) wrote:
>On 6/20/26 09:27, Wei Yang wrote:
>> On Tue, Mar 10, 2026 at 03:54:19AM -0700, Usama Arif wrote:
>>> During folio migration, __folio_migrate_mapping() removes the source
>>> folio from the deferred split queue, but the destination folio is never
>>> re-queued.  This causes underutilized THPs to escape the shrinker after
>>> NUMA migration, since they silently drop off the deferred split list.
>>>
>>> Fix this by recording whether the source folio was on the deferred split
>>> queue and its partially mapped state before move_to_new_folio() unqueues
>>> it, and re-queuing the destination folio after a successful migration if
>>> it was.
>>>
>>> By the time migrate_folio_move() runs, partially mapped folios without a
>>> pin have already been split by migrate_pages_batch().  So only two cases
>>> remain on the deferred list at this point:
>>>  1. Partially mapped folios with a pin (split failed).
>>>  2. Fully mapped but potentially underused folios.
>>> The recorded partially_mapped state is forwarded to deferred_split_folio()
>>> so that the destination folio is correctly re-queued in both cases.
>>>
>>> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
>>> Fixes: dafff3f4c850 ("mm: split underused THPs")
>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>> ---
>>> v1 -> v2:
>>> - record whether source folio was on the deferred split queue before
>>>  move_to_folio() (David)
>>> - record partially mapped state and update commit message (Zi)
>>> ---
>>> mm/migrate.c | 17 +++++++++++++++++
>>> 1 file changed, 17 insertions(+)
>>>
>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>> index ece77ccb2ec0..61013d258eb4 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -1360,6 +1360,8 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>>> 	int rc;
>>> 	int old_page_state = 0;
>>> 	struct anon_vma *anon_vma = NULL;
>>> +	bool src_deferred_split = false;
>>> +	bool src_partially_mapped = false;
>>> 	struct list_head *prev;
>>>
>>> 	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
>>> @@ -1373,6 +1375,12 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>>> 		goto out_unlock_both;
>>> 	}
>>>
>>> +	if (folio_test_large(src) && folio_test_large_rmappable(src) &&
>>> +	    !data_race(list_empty(&src->_deferred_list))) {
>>> +		src_deferred_split = true;
>>> +		src_partially_mapped = folio_test_partially_mapped(src);
>>> +	}
>> 
>> Hi, Usama
>> 
>> I am afraid there maybe a race between migration and defer_split.
>> 
>>                 A                              B
>>   migrate_pages_batch                   deferred_split_scan
>>     migrate_folio_unmap                   list_del_init(&folio->_deferred_list)
>>       folio_lock/folio_trylock
>> 
>>     migrate_folios_move
>>       migrate_folio_move
>>         list_empty(&src->_deferred_list)
>>                                           folio_trylock()
>>                                           requeue:
>> 
>> In case list_empty() check happens after folio removed from defer_list but
>> before requeued, we will miss this folio.
>
>deferred_split_isolate() would grab a reference through folio_try_get().
>
>How can we migrate a folio with a raised refcount?
>

Thanks, I missed expected_refcount check in __migrate_folio().

>-- 
>Cheers,
>
>David

-- 
Wei Yang
Help you, Help me

