Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7882C5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 02:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E15FC6B02BE; Thu, 13 Aug 2026 22:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA7276B05F6; Thu, 13 Aug 2026 22:22:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8EAD6B05F7; Thu, 13 Aug 2026 22:22:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0DE6B02BE
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 22:22:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 196CD120251
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:22:33 +0000 (UTC)
X-FDA: 85098276186.12.2148CD5
Received: from mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1585820002
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:22:30 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wmUdRuOF;
	spf=pass (imf31.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786674151;
	b=hodyF3RqMQYUOZ/gm7mPrTjjlEjJ7Zzwclc9D0wgCt+ib3nX7HlVK8XR/fg8L4zBSk/LOI
	Uh48wURvee4XURkzvWpcsg20Vx1cXZA+2D86qOsm+ZIBOZ76ZLgbSwuksw9eKhLfT/efNZ
	eRz8SRNUoKCX+hDKxoePR1LHSXUE6Wc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wmUdRuOF;
	spf=pass (imf31.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786674151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sk4O133+I01peB5WjJSpr0sUvoPi+fNt0Pt5sexV8I8=;
	b=D/7IB+pEnU1BoJaSL5gfbN2bsEuw4cqwFTOXD1/G1VuTahg4tx/FBKAu5H6N1vJGez6x/X
	PU8l5SLHjcP2CTJNtuk9larDdkuft0H5KtZ7AhXsTiT6PPaZoAUwKunhbeeuBZnX0fAE+r
	mNciSHZDPhIaHasnWXcytlyLzOUvrCg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JU6xpogHPmDMSlDtNSPKwKSCuJrjX9ZxEFdYEDJQdKs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786674149; v=1; x=1787278949;
 b=wmUdRuOFtZOAiPR7pj9Csu+BIU8qJRGZXvPpQ2QBErQGauGiKHzP6SACPvRTFapxDDlB/7ZN
 fqxriC2ul5fp7eG2PaN4Ydel1Yy6dAEln1AG6e7oZ/auTBqe9dZuUXyAn/hJ2x+7O6W2wPu2nne
 W7ERz/+aZtg4fNZbf16czdu8=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.63.123.245] (14.29.108.90)
	by smtp.migadu.com with ESMTPS id 1d9bbf50f91c581b;
	Fri, 14 Aug 2026 02:22:29 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <c10dd51b-b439-4415-acfb-83a4024346cb@linux.dev>
Date: Fri, 14 Aug 2026 10:22:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/mglru: preserve inactive placement when enabling
 MGLRU
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Brian Geffon <bgeffon@google.com>,
 "Jan Alexander Steffens (heftig)" <heftig@archlinux.org>,
 Steven Barrett <steven@liquorix.net>, Yu Zhao <yuzhao@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260813110230.2124785-1-ridong.chen@linux.dev>
 <CAGsJ_4xBQ1r7_rzmu7fBvuy6c3eZCW0Xq=puXtoiGf=JeVnjvA@mail.gmail.com>
 <CAGsJ_4wEpmxZyDFj5eXwEDY_Rbveue552OqqiyZ2MOJw2TTrrA@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4wEpmxZyDFj5eXwEDY_Rbveue552OqqiyZ2MOJw2TTrrA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1585820002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: zisagna8b4acnp6n1bhgr3pg5a6cj7yo
X-HE-Tag: 1786674150-776271
X-HE-Meta: U2FsdGVkX1/LuhyXAEOcCcQbq8iwAUgB111O+WFVoR/irw61VauhL0Zvq4hn+xiAMOvgoDPJk4iQ2TlUCtBSTLWe+aMI5xgRr9w9/mntpkjhTHw90O7oODdbx3ujjjZwoPMJPFfW1ONINALB5askCSgyFu9MSaI0T8px07ezSJ5geuUdTMvrJVNU9hswmA9N6l/36hQBB7IHJ57ag0BnzwSAludvGQMcAUXjjs6j9ZKf5DEh+xqoIFr9qD77vGxxoKfay51Bqf2GDPlbskfAlUZy2uTLXaH4yYD03hJk7bDkHEB3fs2V4s2WIoZrxY7+AOCbXgjKPoqS1aMGQnYpsJEFDOpEoE0vSvxAF3D1Tk4NSi1UYBI+tyjIKN20Lzc3D4hTWUsiC3w7ANvmMOKj7+Ai26fLUuxPv4LpAbjoJP0qxucmJYOP7vtW+t61hDfrGBuCdHLz3garKocuE9WLqBWFjv+w8Ecj7KHd3RFPSdKfha1SlwtGzMf7F0kgZXpJCnZ0dB1tt0G1lxAW9iqNVm/gor8A+f1OMCe9HRFhlEeQ8Y1tBPEvwtlt2y58UVtuvliYPi1wrhk0sXbbTDhmYdPLNUhDUn5EyH+GMO3sLWnnzUgHND4NE4J3lgzK3moLIAuaiMS95Vo11W1+dDCKxRXKS8IHcYjQGYfpnJ+HfVQ6pJ+8D4BncFgYa3I/H9CK1JdSFhv2O5SB5BrnoUWJvVr18/6m3qj2qVqZOsCLZHNtO+v9Yg/1pOn7sz6p6t8a/AYjRbwLLRvSooTp44c4GPv42FZa0VAY8QQQ1sdBoruMUce+dB2hxPQND58Qor7uP/9RCxlgkD1LB2noYnpqIdFk4FF3G+pTJsY2ebBd8I2ta6Nnj6V7taTPX3Oa8EbZy5BNXkY9Q37TuCXMmKs37F+67vJSD7DOPJYqNcBGzYZP3dvCjQlZWUMMldEQUQvgYg43JWDxAkhhBA5Muma
 GTT572Av
 uFdGD7ZPYoW5io/Zh6zTs6KDYuSZJrgZonGP5E01uNSRm+HPAUeUkvMLQYln6UFeTIYnrPMijDOZ+rUKC/oU7kBZgjPC/adw3AZEn2hSy0kbrF6s/RhYWOxPV6KIE7C0FxBs6WYLRLxmL3IZ1zI+p0siI7fcDAAHkDXbHmHI8cXY2SzYLtq4VUOKq7EMgp5cIwL7Qol6sfc/sXKU3MGIg8X2zab7pBQRCpe9xdoBadFYMfN+OwfwGvdi4jqXhuuBnCTzDz3z+9QY/ks5uf3+UW1OrsZVkTA5fpdADAwkKse1j3gWHeNJGGwGHDepRLtJBAaqblgwDRBlxYlZnJWFlGMJoqcbLbXry6hLW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/13/2026 7:37 PM, Barry Song wrote:
> On Thu, Aug 13, 2026 at 7:24 PM Barry Song <baohua@kernel.org> wrote:
>>
>> On Thu, Aug 13, 2026 at 7:02 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>>
>>> From: Ridong Chen <chenridong@xiaomi.com>
>>>
>>> When the LRU is switched to MGLRU (echo y > /sys/kernel/mm/lru_gen/
>>> enabled), fill_evictable() re-inserts every folio via
>>> lru_gen_add_folio(..., false).  With reclaiming hardcoded to false, an
>>> inactive anonymous folio (no PG_active, not in the swapcache) takes the
>>> "gen = MIN_NR_GENS" branch in lru_gen_folio_seq() and is seeded at
>>> seq = max_seq - 1, which lru_gen_is_active() treats as active.  Its
>>> inactive placement is lost and NR_INACTIVE_ANON is folded into
>>> NR_ACTIVE_ANON.
>>>
>>> Pass reclaiming=!active so a folio from an inactive list is seeded into
>>> an older generation.  Folios from the active list carry PG_active and
>>> hit the first branch either way, so they are unchanged.
>>>
>>> Tested on x86_64, next-20260812, 2G VM + 1G swap, ~1.5G anon pushed onto
>>> the inactive list before enabling MGLRU:
>>>
>>>                           Active(anon)  Inactive(anon)
>>>    before switch (legacy)        2952         1548792   kB
>>>    after `echo y`, unpatched  1552052               0   kB
>>>    after `echo y`, patched      15144         1536636   kB
>>>
>>> Inactive file folios stay inactive either way (NR_INACTIVE_FILE is
>>> preserved).
>>>
>>> Fixes: 354ed5974429 ("mm: multi-gen LRU: kill switch")
>>> Assisted-by: Claude:claude-opus-4-8
>>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>>> ---
>>>   mm/vmscan.c | 7 ++++++-
>>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 94fc4f25e99f..2befc8d7dd3f 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -5319,7 +5319,12 @@ static bool fill_evictable(struct lruvec *lruvec)
>>>                          VM_WARN_ON_ONCE_FOLIO(folio_lru_gen(folio) != -1, folio);
>>>
>>>                          lruvec_del_folio(lruvec, folio);
>>> -                       success = lru_gen_add_folio(lruvec, folio, false);
>>> +                       /*
>>> +                        * Keep a folio from the inactive list inactive:
>>> +                        * pass reclaiming=!active so it is not seeded as
>>> +                        * active.  See lru_gen_folio_seq().
>>> +                        */
>>> +                       success = lru_gen_add_folio(lruvec, folio, !active);
>>

Hi Barry, Thank you for your reply.

>> This is a very interesting use of the reclaim argument, as it is not
>> intended to serve this MGLRU switch purpose. It is really only meant
>> for `folio_rotate_reclaimable()`.
>>

Yeah, I realize tying the reclaim argument to the MGLRU switch is a bit of a 
hack, since it was really only designed for folio_rotate_reclaimable(). That 
said, I'm not blind to it, I just posted an RFC patch to get the discussion 
rolling and see what people think.

>> However, the change itself seems to be *partially* correct and
>> *partially* wrong.
>>
>> One real issue is that inactive is always placed in the oldest
>> generation, while we have two old generations. Maybe we can ignore
>> this for now.
>>
>> but somehow, are we also inverting the cold/hot ordering in the
>> inactive list?
>>
>> `lru_to_folio(head)` always takes the tail, but now we are putting the
>> tail before the head folios.
>>
>> Because reclaim == true will use list_add_tail().
>>
>> if (reclaiming)
>> list_add_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
> 
> I guess we can fix this by iterating in `fill_evictable()` from head
> to tail order.
> 
>    struct list_head *pos = head->next;
> 
>    while (pos != head) {
>     struct folio *folio = list_entry(pos, struct folio, lru);
>      ...
>   }
> 
> Then the oldest generation will maintain the same folio order as the
> inactive list.
> 
Thanks for the suggestion. Traversing head to tail does fix the inversion, but 
we need to distinguish active from inactive during iteration, because they are 
inserted differently: list_add_tail() when reclaiming, and list_add() otherwise. 
That said, the reclaim argument usage still feels off to me—I'd like to hear if 
others have a better idea before we proceed with further changes.

-- 
Best regards
Ridong


