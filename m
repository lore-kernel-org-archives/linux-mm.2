Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2079BC982E6
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 11:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E946A6B0088; Sun, 20 Sep 2026 07:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E456F6B008A; Sun, 20 Sep 2026 07:12:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D33CF6B008C; Sun, 20 Sep 2026 07:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE11D6B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:12:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EECE41A0437
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 11:12:17 +0000 (UTC)
X-FDA: 85233876714.18.2A7438A
Received: from mta1.migadu.com (out-4.mta1.migadu.com [95.215.58.4])
	by imf18.hostedemail.com (Postfix) with ESMTP id A17201C0007
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 11:12:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vHp+Hvb+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.4 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789902736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F+1wZBnUZ7Ppi2dJwlzs+Pd3nJ2dhxwKPuaJcpmOPkM=;
	b=hijt6HSiD+Lx/Nurdo0NdXUoNZfxQfZ/iOGdBFhGnG/3kfmtCYwYlNSjt7VqxUzuawxk2c
	De4TyPu1SHRXY+knZpis03PhnOkiW5J5I7LtufffGDIcRaB3Rf7xV/moY/nYiLfpMh73q7
	7MDcdhXKjeS2UzD02SIWJmBLuVqdSJ0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789902736;
	b=1sNP4JfN9JDWu7i0XFENTUkyB/gsQPxxz/YVe1PiBgA3dScVpNQeau7NNpfMZFVKYSUo5l
	mNpBElbJ3kRE2/aAAIJuRgOs98RyUeQKXuRoJWp7J/Rck9mxQYnagivcLS/rIbNbGI3xDP
	UTE7StrYG5O2YRhaKInPIb7h3oBZmQ4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vHp+Hvb+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.4 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CzJCrm1JG/Bdu/TaUWFhlC0tN1b8yrUeWHq+eUql9jI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789902733; v=1; x=1790507533;
 b=vHp+Hvb+eEPj0nhoQpet0POTAc8YKQzWU0LTiz3uOnbQfe7FOiwdiyiyA4Z8eDJiG8mfRGDo
 Fdi5oJ2HOodgQqFsGgdTIVDDxYqMpEVdLicZEU5nhx1gnqVnsKXG2m/jrM2sAqDT0mmwTXcTm7B
 KM+7InVuhMUEESAkMgqmEQYA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4a53f6ddf8c44ae7;
	Sun, 20 Sep 2026 11:12:13 +0000
X-Mizu-Trace-ID: 4a53f6ddf8c44ae7
X-Migadu-Flow: FLOW_OUT
Message-ID: <63de7ffe-8410-4e88-9e09-02f2cc386539@linux.dev>
Date: Sun, 20 Sep 2026 19:12:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new] mm: vmscan: put rotation-missed folios at the LRU
 tail
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260920043015.3126317-1-ridong.chen@linux.dev>
 <CAGsJ_4xmoGWULDVNGj0LzRFFfxM4VVGg4Bx5Pz5cUfXx9uKrtw@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4xmoGWULDVNGj0LzRFFfxM4VVGg4Bx5Pz5cUfXx9uKrtw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A17201C0007
X-Stat-Signature: b7mtdtf5bq8wxmkabg43xm79t1bnqrkq
X-HE-Tag: 1789902735-936964
X-HE-Meta: U2FsdGVkX19jYdydBasrYp2+0u6/Oecwb7EkF+M+4LNHeO1W83Uhe4IBUTc0AT/HW1ldG1+ooaGyIloEX6dZXpEAEIbUdbsu42JMb+7/syI6nRnazrrZGTpAiGEO68bw7odYU17J691FYDQ0W2Iq9dDINwEQO4MGZUOcDoIu13vsWJp798IxbfHP+U4GGgZLYHGS+LKoj1sWrIOJCs81mVPBXUyY4qqMQOHvSggrmGn8CE6BfLIYWKnJsf885yewxR1nIOSpQxTEL3sGQu1RItdkoYWCDin/1/OTW6HaVBjRPH4Op5jNnFBZV2SW0ZdwnZ4JUc4Bdhpxwm7aMuP36q+i+LHAiBmT1lPT2ROLTpvx4StMOeKHVhhfsmoeDnyh+SzKp2FxyO5TfR/Rr+LUcbzV7hTrtw4ttwNNcHa/wsQLKDlOz07lQ3WbfRloTzxGJ/fujZewg7GnoyOtso9AybRcDgaX81Ie2QcJ89drkYPP/OlG+5rHivULPCxA7+oPkjYioU6v8M3Yl50luXqkQaeiGpgPM+0mucX/2Sm7ZBF+KgJMLzLYbjw6SpB4KuROHHriYMjJX+TD4J5NK7A6UtXuH9H9fS+IhQw8qkePk5n0sM0paI128gVowbmWG+FSBompdOCRha+AXGRvTSuJu+H57BkiQhhj+4kGcufuul269b9htTu+PIhenlQE9Dqs4diKKLhfeqnVS7trlmPwnGq1PoOTPfPk/rgAD6fyRkN18Q/Fv7eekiDOAwngR2YPUW3YuCogWbRfTz2xFs2q6iWLl6eFttON1tCrUYVwVL69WL+M3rhi8b6GqvjpFrFZvDYWi/TjEWlKx98uISD7iJFjSYcfKIX/6cSzC4nYskH6zCBGP5qC556vb7E+d7m/USBBGR/4bCEcGsHVkYFQeJrqnyrUtdP0ztg475bhHREi2xH6YQmCRB5bV0/ggzPPKDphzuQcs1cwgHuVwqH
 5GWZiic8
 1gZ39gCTqTWJ5qGHODsorA5rzMMUdgYwVIUrSY4a595YkpmI5kys7KIkfKGiDC4PQLZbQkxHB4nMt1UOHKGmGxJTuiZUF2Ou4Ov2GbYn6kp1C4nhf70VHr1LDmzLCXjKgJ5IgqQ7ZQ63Rv2txuuNCVrxtKgp3IJv1d5UO+o0EUuGkX2KGb8rgC/cKU3S5Cuy7FDP1amQNRcEOJ8zhlbGfWUxKpnQ1xRE1T+/ljNXt6we5KEc6DTwz2D2ypPcgspv59dsN+OHNn5D9L8cCbhr4oArp4b0veZQPDgB340ADh1Y/RLA/HF3S1baa/gusIg+MlCW3ompOAGOMb+fitKoO+nGht8HO2b5rR3iyn4cT0eIpM4lbPc60Wa6DrmdltSqwKt+3RPRkS7+z/4E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/20/2026 5:21 PM, Barry Song wrote:
> On Sun, Sep 20, 2026 at 12:30 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> The page reclaim isolates a batch of folios from the tail of an LRU list
>> and works on them one by one.  For a suitable swap-backed folio on an
>> async swap device, it queues the folio for writeback and, after finishing
>> the batch, puts the folio back to the head of the original LRU list.
>>
>> Meanwhile the page writeback flushes the queued folios in its own,
>> independent batches.  For each folio it writes back it calls
>> folio_rotate_reclaimable(), which tries to rotate the folio to the LRU
>> tail.  But folio_rotate_reclaimable() only takes effect once the folio has
>> been put back by reclaim.  If the async swap device is fast enough, the
>> writeback can complete a folio while reclaim is still working on the rest
>> of the batch that contains it.  In that case the folio stays near the head
>> and reclaim will not revisit it before wrapping around, causing a cold/hot
>> inversion: a clean, written-back folio that should be a prime reclaim
>> candidate is kept ahead of hotter folios.
>>
>> commit 359a5e1416ca ("mm: multi-gen LRU: retry folios written back while
>> isolated") addressed this for MGLRU only.  The traditional active/inactive
>> LRU has the same problem, reported at [1].  A reproducer is available at
>> [2].
>>
>> Rather than re-reclaiming those folios (which would drop the swap cache
>> that may still be useful for a future hit [4]), restore the rotation that
>> was missed: when move_folios_to_lru() puts a folio back, add it to the LRU
>> tail if it looks like it missed folio_rotate_reclaimable() (inactive, not
>> mapped, not dirty and not under writeback).  A new do_rotate parameter
>> gates this so it only applies on the reclaim put-back path
>> (shrink_inactive_list()), not on shrink_active_list() where the list order
>> is already deliberate.  This approach was suggested by Barry Song [3].
>>
>> Only the traditional LRU is handled here.  MGLRU already retries such
>> folios via its own clean-list retry pass in evict_folios(), so it is left
>> unchanged.  The same do_rotate scheme could later replace that retry pass
>> to unify both LRUs, which is left for a follow-up.
>>
>> [1] https://lore.kernel.org/linux-kernel/20241010081802.290893-1-chenridong@huaweicloud.com/
>> [2] https://lore.kernel.org/lkml/46037a37-4cf6-448e-a94b-30a4d16e8814@linux.dev/
>> [3] https://lore.kernel.org/lkml/CAGsJ_4zwP3_+EYY5Ug9EJ+yD1UdxsBSGr25u8s1K3u_i7LH3Zg@mail.gmail.com/
>> [4] https://lore.kernel.org/linux-mm/20260911121341.178028-1-alex@ghiti.fr/
>>
>> Suggested-by: Barry Song <baohua@kernel.org>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   mm/vmscan.c | 21 +++++++++++++++------
>>   1 file changed, 15 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index e200ce3eb056..026b844c681f 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1971,7 +1971,7 @@ static bool too_many_isolated(struct pglist_data *pgdat, int file,
>>    *
>>    * Note: The caller must not hold any lruvec lock.
>>    */
>> -static unsigned int move_folios_to_lru(struct list_head *list)
>> +static unsigned int move_folios_to_lru(struct list_head *list, bool do_rotate)
>>   {
>>          int nr_pages, nr_moved = 0;
>>          struct lruvec *lruvec = NULL;
>> @@ -2018,7 +2018,16 @@ static unsigned int move_folios_to_lru(struct list_head *list)
>>                          continue;
>>                  }
>>
>> -               lruvec_add_folio(lruvec, folio);
>> +               /*
>> +                * Put folios that may have missed folio_rotate_reclaimable()
>> +                * at the tail to avoid cold/hot inversion.
>> +                */
>> +               if (do_rotate && !folio_test_active(folio) && !folio_mapped(folio) &&
>> +                   !folio_test_dirty(folio) && !folio_test_writeback(folio))
>> +                       lruvec_add_folio_tail(lruvec, folio);
> 
> sashiko says:
> 
> "Could this heuristic indiscriminately place un-reclaimable clean folios at
> the LRU tail, ensuring they are immediately re-scanned in an infinite loop?
> If shrink_inactive_list() isolates a clean, unmapped file folio with an
> elevated refcount (such as from a concurrent GUP or speculative lookup),
> it will fail __remove_mapping() and be placed on ret_folios.
> Because this pinned folio matches the !active, !mapped, !dirty, and
> !writeback checks, it is placed at the tail of the inactive LRU. The very
> next isolate_lru_folios() pull from the tail will immediately isolate this
> exact same folio again, creating an infinite loop that prevents any other
> folios from being reclaimed and causes kswapd to spin at 100% CPU."
> 
> This seems to be a valid concern. For a clean and unmapped folio, we
> may still fail in `__remove_mapping()` if it is pinned somewhere. So
> perhaps we can add a refcount check when fixing the rotation.
> 

Thanks, I will update.

-- 
Best regards
Ridong


