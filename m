Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85E9FC5DF81
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 01:54:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759396B008C; Thu, 20 Aug 2026 21:54:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 730836B0092; Thu, 20 Aug 2026 21:54:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 670826B0095; Thu, 20 Aug 2026 21:54:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3FEB86B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 21:54:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE7CDC0213
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:54:53 +0000 (UTC)
X-FDA: 85123608066.27.DD4D91A
Received: from mta1.migadu.com (out-115.mta1.migadu.com [95.215.58.115])
	by imf26.hostedemail.com (Postfix) with ESMTP id B01C3140005
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:54:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i1moms9R;
	spf=pass (imf26.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.115 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787277292;
	b=yuUPWwyBpfD87PiqE7gMnEmZWFdSemW6kQJX1EWqbCsg0XBckH/isc4j5hT/p/fdlCoOjo
	XNeqr9B4pgizcskg8837SVdt51OxX7FsbAZZTXZlzSs/hsx6CmyEG8sg59gi1MqZ4qewse
	IJ9NHBq5Grrf18RJoBWL1sQd8gN+esE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i1moms9R;
	spf=pass (imf26.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.115 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787277292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c2MA7l2HIV79Io8iXY28cIa6Cij5CFoy8Wjne75N3Lo=;
	b=pDkJS9xOGRHgCE7lxJbDl/f6fIPXvCDaLMXYVxXgBz0an3ydwTutRTwwCpQWYKTud02GHX
	rugeW/RitokZTevh6PWLyaT4FKyycUutTDT0cJiwI/KRIYQl+F23Zy0N+0u08wHxeeFwo3
	eJ+wXM32mKE/ir/xJfSfrTeTUk1MRd8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9222hT0hYb3f7vr5tolxWX9+QXMW0+zV3IKz4ky1kFA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787277288; v=1; x=1787882088;
 b=i1moms9RWlP5YSy1UNEEH0F4bNFfCqd6uQOdO2temUnUzaUslJfWCbcCeozf89reeqFlpbFy
 c4yQN8r3bOog46o6W8+8419cjE0AWeMudCMK7s++vaiaZCWNWTeh2srFIN1JymqFFUD0XNPJLpv
 GS4wwO6JKiEajFk1J4c6Pbek=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.63.107.123] (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 4ef687fe756c6a11;
	Fri, 21 Aug 2026 01:54:48 +0000
X-Mizu-Trace-ID: 4ef687fe756c6a11
X-Migadu-Flow: FLOW_OUT
Message-ID: <3fb795db-e7e9-415b-9a27-a99bdd34b090@linux.dev>
Date: Fri, 21 Aug 2026 09:54:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mglru: preserve inactive placement when enabling MGLRU
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Steven Barrett <steven@liquorix.net>,
 "Jan Alexander Steffens (heftig)" <heftig@archlinux.org>,
 Yu Zhao <yuzhao@google.com>, Oleksandr Natalenko <oleksandr@natalenko.name>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260820072641.253591-1-ridong.chen@linux.dev>
 <CAGsJ_4wq46FkDQ_MhvEvtgdUQN5A_+_P+b6gbDvfEadus3WAaA@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4wq46FkDQ_MhvEvtgdUQN5A_+_P+b6gbDvfEadus3WAaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B01C3140005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ah69zxd7ekh3msnujyfsupguqjescwbt
X-HE-Tag: 1787277291-627233
X-HE-Meta: U2FsdGVkX199xO8GCKPms4WkzZ/dYSFPb1C+EOcv7DCJ6o+Pqfgrg31/GgVB0nPG3Cqgx3rLt2lUa9cw8jy/aHzJPTT+kh0bYlcjwTsuuRCbSPqwBAVgmBTXLKU5gCzpM7TZcrCjLbj6laCbR9LUrV9Ne+rsL98Y87qIcMUtXsxRF7obZ2p7QCLNhxlpcYGh3KXuIj1ZBUj6y6QlXEMnuHawttwW9A1r7TnJTcS1I2YtLDFecVJlvLLRgEXE3kOOoatzWPJJi+KwLPZjh0b6HvA4mFD3Ew2VgB9OODIdwfKlpzlG3tWFjGSzp8dm2vx+yMs6CQh4RBp2l+zdJGz7atWUlekwCc9lTINTZG2SJUL0CqXaGe0o0L7CiaK65jp5qojKYbMMvY1QLpenb7U93lzmXLW9kAvuPiH0XE5acw82jvU9shMjxSVN0Kbo0pumjKQLPwy5CQLPq8GiNUJDJ4UgVA3doTyzY9mc/QSI/NONhdT3MwqOJDkL42eC/0JAfeo8Z5CqHDuYr0OShUazySR1Y2pDHRiaVJ0K91ojJzj/MjIrnKcYBkwgY0J++YILgHQm9itq31LcdhLea4BOlEWwavTLJpqd2QrVWxRF1KUgE82BPmOSD55oadEgyHJojj90uRlEvxmqQPXCaL2wZTv2XPbaDqGpuwbkvNfxGwlkIzwW3D1Empho249gvxCknvq/vf0ONbLSlTGDuoyPCU+ri/bUTBPR/T7Hz9ZhYaPL0A+01+c5hcCZkiDHrg/CFiXQrWEPp2dXSG86POeFyVhWOzeGYM96Fg2H6NSgCeItTzeI0XBViYie4wWez4I+oXyGDIW0+Ia5QwENGp8+JrBcO3s8nx1jxyDB2Ke5oQ56599hEk08DaiLLVE6M+dD4jBJI2qgDTMDkupZvA/SJC8NbYh8D/AoM99d3O171j7xO+NBg7ptgC3CJVB/qj2Z0UKpagxUAD5Yax7mwCE
 nFtB97mt
 ybsZ7bWpGzbxowoh4b7MQxzPLrPnzI53+bf0Fwzh/81BwKXrVxK6UL3FLaMkX/0yR/xroCoEYYB5v7rrKCBpUk2J6vKQMtx5GJtpZfce8nQiDCTNUZQUEqjnl5E+ljkmlqZEJUduAicoIMtwjiryuLQmQDimFCszQ8Ah30ZgBTAj89G05MJrm7Bxyp4+jUuaVOoFh5SqFDQDETpRkiunHvyEooXmxX1xZ/FlhlZaMGOiy9475kX76+NUF29DoPQjZX5C1pZjVzEbpMwG6oqrIM/5r9Wu/7JAPeEU8EeUys5nN0UYSWROt5rW9HnaQlNXyWLNtJtXQ0eMWCmnEDhisQYxka3OA+GS/pAES
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/20/2026 3:50 PM, Barry Song wrote:
> On Thu, Aug 20, 2026 at 3:27 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> When the LRU is switched to MGLRU (echo y > /sys/kernel/mm/lru_gen/
>> enabled), fill_evictable() re-inserts every folio via
>> lru_gen_add_folio(..., false).  With reclaiming hardcoded to false, an
>> inactive anonymous folio (no PG_active, not in the swapcache) takes the
>> "gen = MIN_NR_GENS" branch in lru_gen_folio_seq() and is seeded at
>> seq = max_seq - 1, which lru_gen_is_active() treats as active.  Its
>> inactive placement is lost and NR_INACTIVE_ANON is folded into
>> NR_ACTIVE_ANON.
>>
>> Pass reclaiming=!active so a folio from an inactive list is seeded into
>> an older generation.  Folios from the active list carry PG_active and
>> hit the first branch either way, so they are unchanged.
>>
>> reclaiming also selects the insertion end in lru_gen_add_folio():
>> list_add_tail() for inactive folios, list_add() for active ones.  Both
>> the legacy LRU and a MGLRU generation keep the hottest folios at the
>> head and the coldest at the tail, and reclaim takes from the tail.  To
>> preserve that order the folio must be taken from the end matching the
>> insertion end, so take inactive folios from the head and active folios
>> from the tail; otherwise hot/cold would be reversed within the
>> generation.
>>
>> Tested on x86_64, next-20260812, 2G VM + 1G swap, ~1.5G anon pushed onto
>> the inactive list before enabling MGLRU:
>>
>>                           Active(anon)  Inactive(anon)
>>    before switch (legacy)        2952         1548792   kB
>>    after `echo y`, unpatched  1552052               0   kB
>>    after `echo y`, patched      15144         1536636   kB
>>
>> Inactive file folios stay inactive either way (NR_INACTIVE_FILE is
>> preserved).
>>
>> Fixes: 354ed5974429 ("mm: multi-gen LRU: kill switch")
>> Suggested-by: Barry Song <baohua@kernel.org>
>> Assisted-by: Claude:claude-opus-4-8
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   mm/vmscan.c | 29 +++++++++++++++++++++++++++--
>>   1 file changed, 27 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 94fc4f25e99f..7be4cec9a838 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -5311,7 +5311,23 @@ static bool fill_evictable(struct lruvec *lruvec)
>>
>>                  while (!list_empty(head)) {
>>                          bool success;
>> -                       struct folio *folio = lru_to_folio(head);
>> +                       struct folio *folio;
>> +
>> +                       /*
>> +                        * Both the legacy LRU and a MGLRU generation keep the
>> +                        * hottest folios at the head and the coldest at the
>> +                        * tail, and reclaim takes from the tail.  To preserve
>> +                        * that order, the end we take from must match the end
>> +                        * lru_gen_add_folio() inserts at: inactive folios use
>> +                        * reclaiming=true (list_add_tail), so take from the
>> +                        * head; active folios use reclaiming=false (list_add),
>> +                        * so take from the tail.  Taking from the wrong end
>> +                        * would reverse hot/cold within the generation.
>> +                        */
> 
> too many words, maybe just:
> 
> lru_gen_add_folio() uses list_add_tail() rather than list_add()
> when reclaiming is true. Match its ordering to avoid cold/hot
> Inversion.
> 
>> +                       if (active)
>> +                               folio = lru_to_folio(head);
>> +                       else
>> +                               folio = list_first_entry(head, struct folio, lru);
>>
>>                          VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
>>                          VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio) != active, folio);
>> @@ -5319,7 +5335,16 @@ static bool fill_evictable(struct lruvec *lruvec)
>>                          VM_WARN_ON_ONCE_FOLIO(folio_lru_gen(folio) != -1, folio);
>>
>>                          lruvec_del_folio(lruvec, folio);
>> -                       success = lru_gen_add_folio(lruvec, folio, false);
>> +                       /*
>> +                        * With reclaiming=false, lru_gen_folio_seq() would seed
>> +                        * an inactive folio near max_seq, which
>> +                        * lru_gen_is_active() reports as active, so its inactive
>> +                        * placement would be lost.  Pass reclaiming=!active to
>> +                        * seed it into the oldest generation instead.  This
>> +                        * reuses reclaiming beyond its folio_rotate_reclaimable()
>> +                        * meaning; it also picks list_add_tail() above.
>> +                        */
> 
> Maybe that's too verbose. How about:
> 
> "Borrow reclaiming=true to place inactive folios in the older gens"
> 
>> +                       success = lru_gen_add_folio(lruvec, folio, !active);
>>                          VM_WARN_ON_ONCE(!success);
>>
>>                          if (!--remaining)
> 
> This is admittedly a bit ugly, but it seems to be the simplest
> approach. Since switching MGLRU on and off is not a common scenario,
> we probably don't want to over-engineer it. So, with the above change:
> 
> Acked-by: Barry Song <baohua@kernel.org>

Thanks.

Will update.

-- 
Best regards
Ridong


