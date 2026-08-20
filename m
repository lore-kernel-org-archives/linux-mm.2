Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64824C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 07:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AC9C6B009D; Thu, 20 Aug 2026 03:31:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75DB96B009F; Thu, 20 Aug 2026 03:31:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 673526B00A0; Thu, 20 Aug 2026 03:31:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38D306B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 03:31:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BFE511C1AE3
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:31:21 +0000 (UTC)
X-FDA: 85120827162.17.1245F1B
Received: from mta0.migadu.com (out-139.mta0.migadu.com [91.218.175.139])
	by imf20.hostedemail.com (Postfix) with ESMTP id A37BD1C0008
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:31:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kFEkMIGL;
	spf=pass (imf20.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.139 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787211080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yqi+DGMegww9afGbnXuRFqRm4Eoq/RbvzInF037TDvU=;
	b=rB4j+WxYKlEeJPMDRUEOf7PSXhhlnPK3BWpSB9Lkf8Piy3OIdOHKZvJz1JZLA9q3/V5S+E
	IZvNyekXuLTe5qqh7p8NY5Jyv2OndzbH12BITf69COj587ZsCOvnkX6siUaZz89Eyqx6yS
	ikkl7v9Asd06e2JDT+12YU9dxxbOzqo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787211080;
	b=TTB9bXCGEtfrHfwx5NfuiaRd4qy1vk6PWaC+H0WLYKWe0+kTxZKCdmMi7I+T3H43LaIhtu
	qpgSL2/HtO6/ZyuIACwWr7uRt0RAfqerNGUW3vp6H4iP8g6XC4niF7vq4NrJ8LyJJ99DTz
	dAns2hL39FsU5/u5/x6s+rKuOdd6GeA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kFEkMIGL;
	spf=pass (imf20.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.139 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2Q6w1Z3LbClB6sJ7/K3H1n0fkpRB+6xPKkq/JisKM60=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787211076; v=1; x=1787815876;
 b=kFEkMIGL3EtQKQIPOfdd0+AjFUIrGLm+w6/B8pCgU3EoRrnUeHd4awsi0p9/IIJ0CIjpgFfq
 q/J9FHCsoevZjNfLpI/bzgh2KnL7IkSG1Wjx8xQ17EzOEpVS2m8p1yTqIB5clWIU5LwJtXX1lLg
 vXhecGIGO4rnu9mk6R1+iRhw=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.63.107.123] (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 90fcd31e707e72bc;
	Thu, 20 Aug 2026 07:31:16 +0000
X-Mizu-Trace-ID: 90fcd31e707e72bc
X-Migadu-Flow: FLOW_OUT
Message-ID: <e6f77371-24df-462a-803d-190eff514712@linux.dev>
Date: Thu, 20 Aug 2026 15:31:06 +0800
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
 <c10dd51b-b439-4415-acfb-83a4024346cb@linux.dev>
 <CAGsJ_4wEojLabqJZRNRH5CVoEoXPRvcw5hbrGSQ6=8ShrCifGw@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4wEojLabqJZRNRH5CVoEoXPRvcw5hbrGSQ6=8ShrCifGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: gheerinsw9swb9nj5xbmjbqwmdfpi3tp
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A37BD1C0008
X-HE-Tag: 1787211079-314073
X-HE-Meta: U2FsdGVkX18rpg4+NlkH7JH4oFcP+Bhq7o85V353+JkNQWqJw+8lAOyamE7aFwLI1FFtZCKrT5NvFas61Uq+KbJCH5LLW4dKJZVxQK3MxJzezY39iN3hc0PxcCnMq9QSJdbznSoqgUU8y4RHcOaHJlIfNHbIVy5hy3ohqP8EXr8EbpsxCk40rT5SbCQY8GHAd3TNVFrLZTFU0LMCyrNDSR0eQHpm/832nbgI0a0IexNJ9w7LFekiAnE04soFFxb+qvypEWP4ypKgHMDrPruZEwQpI5F2A1W8xUjyE5lnUDMdSPj0zuAzNh2YJeSPSxcq4PDlw+G/Cxhj3C/+qmtarhlzA4XJUHVunGsK6a12AcMLhxO4Jk8bwWpdFUntCdY5nvVvNOC4ntNjGQg2DeX+sVYa6FyIsTCohdPTBRAt0hme+yhk3hbgNBGhA+cwX9KPJH/aIYW0SDOW5w1eXoNZzIgaPOMnz5sx5O/NCEAMAIin8yzgALwdu5rpJP8TIXkF9ffhgsTthLDp3X4D8lbtu1LQ4AW5hpylIf5Ah0LeXERnpL6LWvTMNITLOqU6xH396nSYQYAbVEIYoZNl1ClGSls3vS/uPFuSIGyq/EZadbSHW8cFxkTOxd4kUhtNwOKTd0HoKRaU75LWTHYSXVGoiaHqVU5rAT8Y/u6/U/TQye0zBNE50w/KHAMeC3LsM+4bldlqWujAilaFf+LAc8JwCCjuEFYR/qUSg8dPZJyB/nAJi95xS9LC8w6Ogswf1hdmEGXRM6eI3NehKJ5O8wQagxm+o9z/2dgd9bbF0/m7/x5yUVAcPCLAGUVxcTmm4tPr5fIowIp7Bo0rDD1tRRPuwLEovuTIEVtxC8yakliUM5UdRJfOw7ahBK3okcK9pU/Iuw4t3Cnjfxh7DwxXTYncYozGJEmLfjJjQjvHFoamzw4KTQ/EbpU3dAqTzY0H9pOODQ/AHPQ9mknj1Mj4qhU
 tWDqBpEj
 d9vIpGvLNQEo8zY6Z36ptd3MrLWrwTapDqaanfREyE47Z9SX1NIJxY2c8o3vcNBy9wuE6QcEP4U4L9jdlU16S9/iqHLn3v6xMJf/6E94+jhbjnoUpXTf1O2dgCwaOqCeMFmxvf9Km9qWi0da8Fp+CjHb5ASjatri5AWcTK9SoDjed9TwDPNeXNiIGXwXN/MeqX9yqNvPbc6qQER4tLBf9r7sv/LuelLQOLPZDQ55QQBtDqZl3/pKeE9O3eRKJNFTpxqHsEsq52tZJP7le1Cg7Ed9bSiVkwL5laiTE5oNi5BX1ktSJvYS60vDq9+/dVt57gm1KBy8EOFdbAY/nTcRPAcYOvFfnSzeqL6bQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/14/2026 10:31 AM, Barry Song wrote:
> On Fri, Aug 14, 2026 at 10:22 AM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>>
>>
>> On 8/13/2026 7:37 PM, Barry Song wrote:
>>> On Thu, Aug 13, 2026 at 7:24 PM Barry Song <baohua@kernel.org> wrote:
>>>>
>>>> On Thu, Aug 13, 2026 at 7:02 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>>>>
>>>>> From: Ridong Chen <chenridong@xiaomi.com>
>>>>>
>>>>> When the LRU is switched to MGLRU (echo y > /sys/kernel/mm/lru_gen/
>>>>> enabled), fill_evictable() re-inserts every folio via
>>>>> lru_gen_add_folio(..., false).  With reclaiming hardcoded to false, an
>>>>> inactive anonymous folio (no PG_active, not in the swapcache) takes the
>>>>> "gen = MIN_NR_GENS" branch in lru_gen_folio_seq() and is seeded at
>>>>> seq = max_seq - 1, which lru_gen_is_active() treats as active.  Its
>>>>> inactive placement is lost and NR_INACTIVE_ANON is folded into
>>>>> NR_ACTIVE_ANON.
>>>>>
>>>>> Pass reclaiming=!active so a folio from an inactive list is seeded into
>>>>> an older generation.  Folios from the active list carry PG_active and
>>>>> hit the first branch either way, so they are unchanged.
>>>>>
>>>>> Tested on x86_64, next-20260812, 2G VM + 1G swap, ~1.5G anon pushed onto
>>>>> the inactive list before enabling MGLRU:
>>>>>
>>>>>                            Active(anon)  Inactive(anon)
>>>>>     before switch (legacy)        2952         1548792   kB
>>>>>     after `echo y`, unpatched  1552052               0   kB
>>>>>     after `echo y`, patched      15144         1536636   kB
>>>>>
>>>>> Inactive file folios stay inactive either way (NR_INACTIVE_FILE is
>>>>> preserved).
>>>>>
>>>>> Fixes: 354ed5974429 ("mm: multi-gen LRU: kill switch")
>>>>> Assisted-by: Claude:claude-opus-4-8
>>>>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>>>>> ---
>>>>>    mm/vmscan.c | 7 ++++++-
>>>>>    1 file changed, 6 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>>> index 94fc4f25e99f..2befc8d7dd3f 100644
>>>>> --- a/mm/vmscan.c
>>>>> +++ b/mm/vmscan.c
>>>>> @@ -5319,7 +5319,12 @@ static bool fill_evictable(struct lruvec *lruvec)
>>>>>                           VM_WARN_ON_ONCE_FOLIO(folio_lru_gen(folio) != -1, folio);
>>>>>
>>>>>                           lruvec_del_folio(lruvec, folio);
>>>>> -                       success = lru_gen_add_folio(lruvec, folio, false);
>>>>> +                       /*
>>>>> +                        * Keep a folio from the inactive list inactive:
>>>>> +                        * pass reclaiming=!active so it is not seeded as
>>>>> +                        * active.  See lru_gen_folio_seq().
>>>>> +                        */
>>>>> +                       success = lru_gen_add_folio(lruvec, folio, !active);
>>>>
>>
>> Hi Barry, Thank you for your reply.
>>
>>>> This is a very interesting use of the reclaim argument, as it is not
>>>> intended to serve this MGLRU switch purpose. It is really only meant
>>>> for `folio_rotate_reclaimable()`.
>>>>
>>
>> Yeah, I realize tying the reclaim argument to the MGLRU switch is a bit of a
>> hack, since it was really only designed for folio_rotate_reclaimable(). That
>> said, I'm not blind to it, I just posted an RFC patch to get the discussion
>> rolling and see what people think.
> 
> I think it’s fine. Just update the comment there and mention that it
> can serve another purpose as well.
> 
> [...]
>>> Then the oldest generation will maintain the same folio order as the
>>> inactive list.
>>>
>> Thanks for the suggestion. Traversing head to tail does fix the inversion, but
>> we need to distinguish active from inactive during iteration, because they are
>> inserted differently: list_add_tail() when reclaiming, and list_add() otherwise.
>> That said, the reclaim argument usage still feels off to me—I'd like to hear if
>> others have a better idea before we proceed with further changes.
> 
> We can change reclaim to a tristate integer, or simply make the
> following change and add a comment explaining why?
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9e52f49114e7..5e624d0316bc 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5403,7 +5403,8 @@ static bool fill_evictable(struct lruvec *lruvec)
> 
>                  while (!list_empty(head)) {
>                          bool success;
> -                       struct folio *folio = lru_to_folio(head);
> +                       struct folio *folio = active ? lru_to_folio(head) :
> +                               list_entry((head)->next, struct folio, lru);
> 

I've sent a new patch following this approach.

Link: 
https://lore.kernel.org/linux-mm/20260820072641.253591-1-ridong.chen@linux.dev/T/#u

> Or you could even move the entire inactive list to the oldest gen
> instead of moving the folios one by one. Then you can avoid dealing
> with the reclaim argument entirely.
> 

However, since MGLRU distinguishes zones, we would have to move the folios one 
by one. So I've dropped this approach.

-- 
Best regards
Ridong


