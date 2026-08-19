Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B12D2C5DF7D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 02:15:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E6F86B008A; Tue, 18 Aug 2026 22:15:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 996E56B008C; Tue, 18 Aug 2026 22:15:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 886426B0092; Tue, 18 Aug 2026 22:15:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EB096B008A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 22:15:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 888CA1403B8
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:15:12 +0000 (UTC)
X-FDA: 85116401664.25.87301AA
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf05.hostedemail.com (Postfix) with ESMTP id 823A2100009
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:15:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XKTy7Be9;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787105710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=02UHFtSIN6JDJ4bj3MePIt9/xxUXCOrrST878CoL+Xw=;
	b=gURhPSKK9GEW+keMnVJztTM3tQYk+JWvp2KT2Y4wSSxY5sDjhgEDbdIDzkJHWQl0WuSkld
	M7Dtz9LBrdcM3dQsjZiYvrJfpJDEpYAkFk0XMji5S128iEn7bz9W0p8wiEnpdRDRCVlquX
	ee+WV2pwwTlv/qdLfRGRL8XVN6tS2Ew=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787105710;
	b=t7I8U0+krd9Swx6bcmQ7lmxLgr+v0TXCJc8Ow8sDPyXC/Y6HiQDW4BqEMaGSQsT+o4Jm67
	b0b8m9dxfZEnIvnYz7z69EmKkgjJ9HXClsUxMgFKuZ/xCNIxEAWqhWSQa8v5WsL7785P3G
	KzynRM4KbARynjz6P3CG2yz6mvYGINk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XKTy7Be9;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787105707; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=02UHFtSIN6JDJ4bj3MePIt9/xxUXCOrrST878CoL+Xw=;
	b=XKTy7Be94qIqNCA6ACv9ElxRRjneTViBrD90loccZ74qwwrMf4xdFA0EHKG7PtFueReWJLY1K4LJfig3KhG05OFeAEUTyAqQBjSPRv27pNthvfesY/4zY1RPAagBm9a7X7S1+Vdo03XGF0vp1iiOmN9cfev80EAyTmvEh2hAVx4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X9F2Zqi_1787105704;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9F2Zqi_1787105704 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 19 Aug 2026 10:15:05 +0800
Message-ID: <39871dbf-25e3-4518-9942-a733dbb6acf5@linux.alibaba.com>
Date: Wed, 19 Aug 2026 10:15:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v3 2/2] mm/vmscan: apply too_many_isolated()
 throttling to MGLRU eviction
To: Barry Song <baohua@kernel.org>, Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
References: <cover.1787056208.git.zhuhui@kylinos.cn>
 <4b4d4e3065e36f1b60dd69e8276cb92082f393a6.1787056208.git.zhuhui@kylinos.cn>
 <CAGsJ_4xKM1R95TEpKoicGYQB8Qafez6hKJF=Z98A_2j43X5GAA@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4xKM1R95TEpKoicGYQB8Qafez6hKJF=Z98A_2j43X5GAA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 47n46yykufqei8dqctbd3hh376fikq55
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 823A2100009
X-HE-Tag: 1787105709-822711
X-HE-Meta: U2FsdGVkX1+N4phCLHFbO1CXDF5T6gsfd9FZgQEZDwyWFSZpmCfQkNb7UoAxwhFMmC5ZpldeRnmwojmv2h64QX4PFPaTSr4vuLzxXc4RfhR7VU5VpyosOJCjpXw+lOq+yFLpZi/aU/Pj1CnTuwY22cioR6IWKvk6uhMdx1hj7kgowCgHAaqhW/lN5IwpBp/HcVK05Ag2h76va9lRxuxe0LBUiMvSm+RNJ0AKKrsEI+4d9RyKuNb2NsXVNixjUOeK1UVj5cA8rUWT+GaXaLHPRO35yoA0oNfh4HKODYRNgXhETdDfRVH8E9tSAZsrCSJt7aE/xdYD2BZpqXgyMRL0FM9/KXP8DTEJBlEJYtQk69fYeICv2B3PX9HfX7sVdIO6iE1Z1C6l1bU0APAbinzRqg9mdMjrLZ5rwYiQERm8YUkWm1VBs/UUt+vIki+8E9T9PdyBRU7HKovX2Rvch6yC7py21cjzYSZ9x/Py7f4uuNogX55yowr+KN8RZW9lPa018bH4NkE4LlLn5Xr2tMPAHsa+SoAdHtYGSD5fFeS1TDgBn7X5+SxEhX5tu+RQVTuZoj+fyZhfwyw0Q2qP5njv/EsfPpGLnSRxauXlkitCLmXsIlldJOGA2d8FTxwMnArmBJMdrvKFMlyFWzfw9aut4kuXC+adWQ82cfknmFEpLLTi/1emhnZMu3YMy6oUlxpPKtdcBWhwGqifC1MzN0iD0IKDlBpl0LnPD0DJb0cXvKAHfQU3xTTLCQ/Ya5eQntm5P8WampgxddUwZ9tleIwxyfqqqm0RIYGswo4g694/QtYFpGxa63VwHR721q+OJLM7jf9PYTf+D3e0qq81x+h93e0dNV8pHKaJJL330jXmtIpvUvLAvU9iXXgoBUY0QHUWngcMgCGueGJLnpyomarUmXtUPnb/kxO84JaAkcPXJvqvpFIEUJLWVdrWEL5ImfT3n7jmjdG8EuWHH2NreX9
 RkKuQfWH
 g9TuRnnm0W8qPwv6wQhv6DCevoayLE7agc1uHubfWlTWUgkSJwVds/pmyy41kCLZABsdOquS8yEa3fvNs4Q8x9vjV1RSiYBwoNuS3KB6N1qHUJsj/zhm3XE3aFpcmFas4C0JZmGfG8Il/CgtdmKRQekJQkXnixB1CvXmVuqcujQENhfveH2ZVGEmFuq6Oe5tHOOcVGHVVa6tyN/WCoQhJ5+Crodfd5lX/yE2B/SmeG5owpZAvbU/1wr2hn52NX3/mMvdmgkIU8aAx1QendYbUQqtxfVRMBQDpwUBzKR+L2yeZrswJx3zK2YSKWy2HVdhousjibWIwFDriEquIYgE7uFJqMs+5p4XfMyGJg1l0evOWlrtIFQsa4wm6H3ECbtfbSQ1mpdT/z9ymTKY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/19/26 6:06 AM, Barry Song wrote:
> On Tue, Aug 18, 2026 at 8:49 PM Hui Zhu <hui.zhu@linux.dev> wrote:
>>
>> From: Hui Zhu <zhuhui@kylinos.cn>
>>
>> The legacy path throttles direct reclaim in shrink_inactive_list()
>> when too many isolated folios pile up, but MGLRU's evict_folios()
>> isolates folios without this check, which can lead to unnecessary
>> swapping, thrashing and OOM.
>>
>> With the NR_ISOLATED counters now updated in evict_folios(), extract
>> the throttling loop from shrink_inactive_list() into
>> throttle_is_throttled() and reuse it in evict_folios(). Since the
>> type to isolate is unknown until isolation and isolate_folios() may
>> fall back to the other type, check all evictable types with
>> for_each_evictable_type() and throttle if any of them has too many
>> isolated folios.
>>
> 
> I feel this is unlikely to work. MGLRU behaves quite differently from the
> active/inactive LRU, and its `NR_INACTIVE_FILE` accounting is also very
> different.
> 
> With the active/inactive LRU, shrink_inactive_list() ensures that we
> always have an inactive list with pages available for reclaim. With MGLRU,
> however, a generation can legitimately point to an empty list, so this
> assumption does not hold.
> 
> try_to_inc_min_seq:
> 
>          /* see the comment on lru_gen_folio */
>          if (swappiness && swappiness <= MAX_SWAPPINESS) {
>                  unsigned long seq = lrugen->max_seq - MIN_NR_GENS;
> 
>                  if (min_seq[LRU_GEN_ANON] > seq && min_seq[LRU_GEN_FILE] < seq)
>                          min_seq[LRU_GEN_ANON] = seq;
>                  else if (min_seq[LRU_GEN_FILE] > seq &&
> min_seq[LRU_GEN_ANON] < seq)
>                          min_seq[LRU_GEN_FILE] = seq;
>          }
> 
> At that point, we have no inactive pages for the type, so the
> throttle will take effect when the following condition is true:
> 
> too_many = isolated > inactive;
> 
> With MGLRU, however, we can still fall back to the other type even
> when there are no inactive pages for the current type.

Yes, that's a valid concern. So I think we can check the isolation of 
both types for MGLRU to avoid this case:

static bool check_need_throttle()
{
         bool need_throttle = true;

         for_each_evictable_type(i, swappiness) {
                 if (!too_many_isolated(pgdat, i, sc))
                         need_throttle = false;
         }

         return need_throttle;
}

In evict_folios():
	......
	while (unlikely(check_need_throttle())) {
                 if (stalled)
                         return 0;

                 /* wait a bit for the reclaimer. */
                 stalled = true;
                 reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED);

                 /* We are about to die and free our memory. Return now. */
                 if (fatal_signal_pending(current))
                         return SWAP_CLUSTER_MAX;
         }

> BTW, if we are hitting isolated > inactive with MGLRU, it probably
> means the generations are quite imbalanced—we are running out of
> reclaimable generations. In that case, we may actually want
> reclamation to proceed with aging instead.

The typical 'isolated > inactive' case is that we've tried our best with 
aging, but cold pages production can't keep up with isolation speed, 
especially under concurrent reclaim from multiple processes. In this 
case, I think throttling is reasonable.

>> If a fatal signal is pending, fake reclaim progress the same way the
>> legacy path does, so the dying task exits reclaim quickly instead of
>> being held in the throttle.
>>
>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
>> ---
>>   mm/vmscan.c | 71 ++++++++++++++++++++++++++++++++++++++++++++---------
>>   1 file changed, 59 insertions(+), 12 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 98226bb021f3..6fe8824430ac 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1819,7 +1819,7 @@ bool folio_isolate_lru(struct folio *folio)
>>    * the LRU list will go small and be scanned faster than necessary, leading to
>>    * unnecessary swapping, thrashing and OOM.
>>    */
>> -static bool too_many_isolated(struct pglist_data *pgdat, int file,
>> +static bool too_many_isolated(struct pglist_data *pgdat, bool file,
>>                  struct scan_control *sc)
>>   {
>>          unsigned long inactive, isolated;
>> @@ -1856,6 +1856,37 @@ static bool too_many_isolated(struct pglist_data *pgdat, int file,
>>          return too_many;
>>   }
>>
>> +/*
>> + * Throttle reclaim if too many isolated folios are piling up. If this makes
>> + * no progress, the caller is probably looping on unevictable folios, so give
>> + * up. Returns true to tell the caller to stop reclaiming, and sets @fatal
>> + * if the task received a fatal signal while waiting, so that the caller can
>> + * bail out faster.
>> + */
>> +static bool throttle_is_throttled(struct pglist_data *pgdat, bool file,
>> +                                 struct scan_control *sc, bool *fatal)
>> +{
>> +       bool stalled = false;
>> +
>> +       *fatal = false;
> 
> TBH, I find the name quite weird :-)

Yes, that is not what I meant. :) What I mean is to use a readable 
variable to return instead of 'true' or 'false':

static bool throttle_isolated(struct pglist_data *pgdat, bool file,
                 struct scan_control *sc, bool *fatal)
{
         bool stalled = false;

         *fatal = false;
         while (unlikely(too_many_isolated(pgdat, file, sc))) {
                 if (stalled)
                         return stalled;

                 /* wait a bit for the reclaimer. */
                 stalled = true;
                 reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED);

                 /* We are about to die and free our memory. Return now. */
                 if (fatal_signal_pending(current)) {
                         *fatal = true;
                         return stalled;
                 }
         }

         return stalled;
}


