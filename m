Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 552FEC88E5C
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 01:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 307326B0088; Sun, 13 Sep 2026 21:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B6716B008C; Sun, 13 Sep 2026 21:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CDAC6B0092; Sun, 13 Sep 2026 21:48:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E197D6B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 21:48:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 081AF120E49
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 01:48:43 +0000 (UTC)
X-FDA: 85210683726.18.2E8BE3D
Received: from mta0.migadu.com (out-36.mta0.migadu.com [91.218.175.36])
	by imf03.hostedemail.com (Postfix) with ESMTP id AF15320002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 01:48:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="FV4/kvYw";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.36 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789350521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qA9q4QrgW5I6BmI8b6syoVcVHKikBRuOUZ+ecrXhAL0=;
	b=q0xaJeukmExJWF/L6PraPFWtwuZbprOwy5UDZxz1PiDMUDPmyCi8z9DD1ATKkDf9MEPhYB
	LyWTJKnkAUhhgkIEYbV1gVLRdns97V5qOlm9oSVn66JFz7JkmZ5wfwjuMG5mwuYurzfXpE
	9Y+JrWExLQlvXWK3iZlzQkTU0rT5WYE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789350521;
	b=FHLch4JJ3Uoi1DcH999aZ4BqTjxBqYdhIDylc7ZbyQrQA2t35Wdw798K9TyFqRSq944yRA
	JCs0hW2Gxrl8hvozmGnwvqlBb9BHN9NwYGRgL/H91b43GYyXjo4BkdIQ/AbSYlHbWJ3PRn
	x3LPAqz/1hgq5KSg4Wu8M4IY2oY4ubI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="FV4/kvYw";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.36 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=T7VORGWKsb/JUYt0wWYurBz8B2TdDMQVN7LZ2HJpyZs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789350518; v=1; x=1789955318;
 b=FV4/kvYwfSj2mcKU+Fvl1QCnahONDUt2LERuFxxBs6yFY+ynqTrj5L3DkNk1a4jB2kp3G8hv
 z83kYyQSriRwcKJtL1c1zZbdrWF/fj7CuXzwuxZ/+CfcX9iIS3cqCXQnmuxlZS5m4mpiHZnkT0c
 QvlWS0OX127mcd8bJ9CzNANk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 47ecaf45c657b54f;
	Mon, 14 Sep 2026 01:48:38 +0000
X-Mizu-Trace-ID: 47ecaf45c657b54f
X-Migadu-Flow: FLOW_OUT
Message-ID: <dea91675-8011-4e88-99b0-2d8b130bcecc@linux.dev>
Date: Mon, 14 Sep 2026 09:48:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8] mm: vmscan: retry folios written back while isolated
 for traditional LRU
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
References: <20260913100013.3603815-1-ridong.chen@linux.dev>
 <CAGsJ_4xEAS5Bacn8dUxDPoMKwD054zUsfUB3MSGYxGYwicPyWQ@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4xEAS5Bacn8dUxDPoMKwD054zUsfUB3MSGYxGYwicPyWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AF15320002
X-Stat-Signature: suod7q4trwduzhir7q39ozidxy6nba5e
X-HE-Tag: 1789350520-762624
X-HE-Meta: U2FsdGVkX1/zWHE9dKhIbu7xXZ/6+YzpC+p4496sqYmcvWqCa35EiLXpOnJqNfXVPbnScX6bztlZlDQv0A3DrbP/MU4KeCviNKbXjOUH5h3E6UMD1flL9wClVYYwrKDLtvhs935AH5C/EwsifdIgjehn/wmtH7JbPNvLyT6iAdAru2SfUOvKVi1TMbNTCNwDcweY5VPXSAuOXzco79l5aE3Ke+/mDex4d/8vw07/Vf6LEdsxrcaPWeHJsEokP+YBDawC8P3FnpIi63bti6+IqI2ceVGiM1WIQlpC3oG3fqWogKe8sU3Gfubo8xEK7R1wQ6k+Cc52HQzHp/KWBd2u76M7W2UiccrDVZV8wiR+D4ryfC4eQDb9+oT667NFY5Vf7/D9BujWtW8WCy8ulOR7uMgDdEnj8iKxMxSuCqWNbKZPzEzMhcZ2wNkoKHrbayD4n6uM4GXO9h+sAuKww1spfTzpDyR0M/Q6nfaTpuL2wIoPcE5dgL8ybe2J9D5xtYm0vkwLID3MwKZXJDA4Bcrm0fUkZv3JhEkggCFAKj0NFo3qiDXgxyhEIcgR5L3ytC0yf7YqBB5T/77IQTtavM+p1rgqggRmAUYzJ3U2P4PPc24Nish/RgtPv6dPNUTAl4Kra5enMLCec7lFmV9wSsP8PQiQFDJi0m32+4Z58WroPCF1BCjaD89WKDbuvSR5FiFIrn3siuKiqi33VS7gWF/E3s6pfgFhyVxC1t2ZjkYqQ8ctK/Xe2qct0yF7a7IJT1Lcd7quk/nw3PAfulh6LJ5zJlnYh6K+ZawyB+65n6ritf9Fhx66PGLWBqy0WT90x8mF+Dm7h9RAO0UjoTrmHLfuVqn1hMevPEux5T369iKXKhtHWC8wITcm5cK3GpyGJq+dTRwLICnWnVCnORh2JYUeqz52zDz2bpj16xLweS3Uc4rGlttzl7Su4AHGaGN7pkcz4jYF0EUl7GDpgYvrvhr
 X8dLS3Bh
 FMbr4zEMcKd0kxHu3wWCW50C2uGEN7sIuLiIzUwsCTgKvEp5WGaBnVmTv5I3MN0vCsMELetvATo4aLuUuyc5ZjmUmclE4qkJpfCvbDoByOkObI5mw1PTKMdv1Y6rGuUm46iGc3BsP6CxQrQSpOu9bzJah2QUOtVUZtM2TpQ2w7C6s/fFTg2l/yE4p1D4vlYT5zvjJ6QFUgqAcXG22mQ4IeoUv90RyD6caODcFs5688RDBRItyMrSi8IvxAGDKQQP3Me00idJ0YrLLG4R4KtHF6iXlu5Dk8oloCfySreIKwGEgfV+eAyoNpV8K7u+6gTAvy3NQ8GR83cwa014Q+luz4ecCnUUWVqITMDGxmpT6YS3yC0GmCg6vrbP8C1nLCeCFjU2oNzwu1F0+bL3rqcD/CypQNbm1kzo+XBoGAhPhG2oCrI4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/13/2026 7:33 PM, Barry Song wrote:
> On Sun, Sep 13, 2026 at 6:00 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> As commit 359a5e1416ca ("mm: multi-gen LRU: retry folios written back
>> while isolated") mentioned:
>>
>>    The page reclaim isolates a batch of folios from the tail of one of the
>>    LRU lists and works on those folios one by one.  For a suitable
>>    swap-backed folio, if the swap device is async, it queues that folio for
>>    writeback.  After the page reclaim finishes an entire batch, it puts back
>>    the folios it queued for writeback to the head of the original LRU list.
>>
>>    In the meantime, the page writeback flushes the queued folios also by
>>    batches.  Its batching logic is independent from that of the page
>>    reclaim. For each of the folios it writes back, the page writeback calls
>>    folio_rotate_reclaimable() which tries to rotate a folio to the tail.
>>
>>    folio_rotate_reclaimable() only works for a folio after the page reclaim
>>    has put it back.  If an async swap device is fast enough, the page
>>    writeback can finish with that folio while the page reclaim is still
>>    working on the rest of the batch containing it.  In this case, that folio
>>    will remain at the head and the page reclaim will not retry it before
>>    reaching there".
>>
>> The commit 359a5e1416ca ("mm: multi-gen LRU: retry folios written back
>> while isolated") only fixed the issue for mglru. However, this issue
>> also exists in the traditional active/inactive LRU and was found at [1].
>>
>> It can be reproduced with below steps:
>>
>> 1. Compile with CONFIG_TRANSPARENT_HUGEPAGE=y
>> 2. Mount memcg v1, and create memcg named test_memcg and set
>>     limit_in_bytes=1G, memsw.limit_in_bytes=2G.
>> 3. Create a 1G swap file, and allocate 1.35G anon memory in test_memcg.
>>
>> It was found that:
>>
>>    cat memory.usage_in_bytes
>>    1073700864
>>    cat memory.memsw.usage_in_bytes
>>    1413124096
>>
>>    free -h
>>                  total        used        free
>>    Mem:           1.6Gi       1.2Gi       299Mi
>>    Swap:          1.0Gi       678Mi       346Mi
>>
>> As shown above, the test_memcg charged about 324M swap (memsw.usage minus
>> usage), but almost 678M swap memory was used, which means that 350M+ may
>> be wasted because other memcgs can not use these swap memory.
>>
>> This issue should be fixed in the same way as mglru. Therefore, the common
>> logic was extracted to the 'find_folios_written_back' function firstly,
>> which is then reused in the 'shrink_inactive_list' function. Finally,
>> retry reclaiming those folios that may have missed the rotation for
>> traditional LRU.
>>
>> After change, the same test case only wasted about 2M swap. The swap
>> device usage matches what the memcg actually charged.
>>
>>    cat memory.usage_in_bytes
>>    1070301184
>>    cat memory.memsw.usage_in_bytes
>>    1412448256
>>
>>    free -h
>>                  total        used        free
>>    Mem:           1.6Gi       1.2Gi       299Mi
>>    Swap:          1.0Gi       327Mi       696Mi
>>
>> [1] https://lore.kernel.org/linux-kernel/20241010081802.290893-1-chenridong@huaweicloud.com/
>> [2] https://lore.kernel.org/linux-kernel/CAGsJ_4zqL8ZHNRZ44o_CC69kE7DBVXvbZfvmQxMGiFqRxqHQdA@mail.gmail.com/
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>> v8: Rebase to the -next tree, adapt to the current reclaim API, and retest.
>>
>> [v7]: https://lore.kernel.org/linux-mm/20250111091504.1363075-1-chenridong@huaweicloud.com/
>>
>>   mm/vmscan.c | 104 ++++++++++++++++++++++++++++++++++++----------------
>>   1 file changed, 73 insertions(+), 31 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index d1495a7d469d..6e13e570aab8 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -181,6 +181,10 @@ struct scan_control {
>>          struct reclaim_state reclaim_state;
>>   };
>>
>> +static void find_folios_written_back(struct list_head *list,
>> +                                    struct list_head *clean, struct lruvec *lruvec,
>> +                                    int type, bool skip_retry);
>> +
>>   #ifdef ARCH_HAS_PREFETCHW
>>   static inline void prefetchw_prev_lru_folio(struct folio *folio,
>>                  struct list_head *base)
>> @@ -2013,14 +2017,16 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>>                  enum lru_list lru)
>>   {
>>          LIST_HEAD(folio_list);
>> +       LIST_HEAD(clean_list);
>>          unsigned long nr_scanned;
>> -       unsigned int nr_reclaimed = 0;
>> -       unsigned long nr_taken;
>> +       unsigned int nr_reclaimed, total_reclaimed = 0;
>> +       unsigned long nr_taken, isolated;
>>          struct reclaim_stat stat;
>>          bool file = is_file_lru(lru);
>>          enum node_stat_item item;
>>          struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>>          bool stalled = false;
>> +       bool skip_retry = false;
>>
>>          while (unlikely(too_many_isolated(pgdat, file, sc))) {
>>                  if (stalled)
>> @@ -2052,25 +2058,42 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>>          if (nr_taken == 0)
>>                  return 0;
>>
>> +       isolated = nr_taken;
>> +retry:
>>          nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
>>                                           lruvec_memcg(lruvec));
>> +       total_reclaimed += nr_reclaimed;
>> +
>> +       /* Retry pass is only meant for clean folios without new isolation */
>> +       if (isolated)
>> +               handle_reclaim_writeback(isolated, pgdat, sc, &stat);
>> +       trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
>> +                       nr_scanned, nr_reclaimed, &stat, sc->priority, file);
>> +
>> +       find_folios_written_back(&folio_list, &clean_list, lruvec, file, skip_retry);
>>
>>          move_folios_to_lru(&folio_list);
>>
>>          mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
>>                                          stat.nr_demoted);
>> -       mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
>>          item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
>>          mod_lruvec_state(lruvec, item, nr_reclaimed);
>>          mod_lruvec_state(lruvec, PGSTEAL_ANON + file, nr_reclaimed);
>> -       if (nr_scanned > nr_reclaimed)
>> +
>> +       if (!list_empty(&clean_list)) {
>> +               list_splice_init(&clean_list, &folio_list);
>> +               skip_retry = true;
>> +               /* Retry folios were already isolated and accounted above */
>> +               isolated = 0;
>> +               goto retry;
>> +       }
>> +
>> +       mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
>> +       if (nr_scanned > total_reclaimed)
>>                  mod_lruvec_state(lruvec, PGROTATE_ANON + file,
>> -                                nr_scanned - nr_reclaimed);
>> +                                nr_scanned - total_reclaimed);
>>
>> -       handle_reclaim_writeback(nr_taken, pgdat, sc, &stat);
>> -       trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
>> -                       nr_scanned, nr_reclaimed, &stat, sc->priority, file);
>> -       return nr_reclaimed;
> 
> this is a bit weird to move the tracepoint, shouldn't it just trace the total
> number of twice reclamation?
> 
>> +       return total_reclaimed;
>>   }
>>
>>   /*
>> @@ -5006,8 +5029,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>   {
>>          LIST_HEAD(list);
>>          LIST_HEAD(clean);
>> -       struct folio *folio;
>> -       struct folio *next;
>>          enum node_stat_item item;
>>          struct reclaim_stat stat;
>>          struct lru_gen_mm_walk *walk;
>> @@ -5046,26 +5067,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>                          type_scanned, reclaimed, &stat, sc->priority,
>>                          type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>>
>> -       list_for_each_entry_safe_reverse(folio, next, &list, lru) {
>> -               DEFINE_MIN_SEQ(lruvec);
>> -
>> -               /* move_folios_to_lru() culls unevictable folios via folio_putback_lru() */
>> -               if (!folio_evictable(folio))
>> -                       continue;
>> -
>> -               /* retry folios that may have missed folio_rotate_reclaimable() */
>> -               if (!skip_retry && !folio_test_active(folio) && !folio_mapped(folio) &&
>> -                   !folio_test_dirty(folio) && !folio_test_writeback(folio)) {
>> -                       list_move(&folio->lru, &clean);
>> -                       continue;
>> -               }
>> -
>> -               /* don't add rejected folios to the oldest generation */
>> -               if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]) {
>> -                       folio_set_lru_refs(folio, 0);
>> -                       folio_set_active(folio);
>> -               }
> 
> Baolin has a patch which modifies this.
> so probably you are not based on the mm-new?
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?id=519f7768585e372b97e568baf9d4648e6beb6863
> 
>> -       }
>> +       find_folios_written_back(&list, &clean, lruvec, type, skip_retry);
>>
>>          move_folios_to_lru(&list);
>>
>> @@ -6108,6 +6110,46 @@ static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *
>>
>>   #endif /* CONFIG_LRU_GEN */
>>
>> +/**
>> + * find_folios_written_back - Find and move the written back folios to a new list.
>> + * @list: folios list
>> + * @clean: the written back folios list
>> + * @lruvec: the lruvec
>> + * @type: LRU type (only used for CONFIG_LRU_GEN)
>> + * @skip_retry: whether skip retry.
>> + */
>> +static void find_folios_written_back(struct list_head *list,
>> +                                    struct list_head *clean, struct lruvec *lruvec,
>> +                                    int type, bool skip_retry)
>> +{
>> +       struct folio *folio;
>> +       struct folio *next;
>> +
>> +       list_for_each_entry_safe_reverse(folio, next, list, lru) {
>> +#ifdef CONFIG_LRU_GEN
>> +               DEFINE_MIN_SEQ(lruvec);
>> +#endif
>> +               /* move_folios_to_lru() culls unevictable folios via folio_putback_lru() */
>> +               if (!folio_evictable(folio))
>> +                       continue;
>> +
>> +               /* retry folios that may have missed folio_rotate_reclaimable() */
>> +               if (!skip_retry && !folio_test_active(folio) && !folio_mapped(folio) &&
>> +                   !folio_test_dirty(folio) && !folio_test_writeback(folio)) {
>> +                       list_move(&folio->lru, clean);
>> +                       continue;
>> +               }
>> +#ifdef CONFIG_LRU_GEN
>> +               /* don't add rejected folios to the oldest generation */
>> +               if (lruvec->lrugen.enabled &&
>> +                   lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]) {
>> +                       folio_set_lru_refs(folio, 0);
>> +                       folio_set_active(folio);
>> +               }
> 
> as above. please take a look at Baolin's patch:
> https://lore.kernel.org/9214e36bf738fcfba86acc8cea85dff4010f66b0.1788918714.git.baolin.wang@linux.alibaba.com
> 
> 
Thanks, I rebased on the next branch.

I will rebase on mm-new.

-- 
Best regards
Ridong


