Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD011F532E9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 07:22:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C6886B0095; Tue, 24 Mar 2026 03:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E0F6B0096; Tue, 24 Mar 2026 03:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1D356B0098; Tue, 24 Mar 2026 03:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF29D6B0095
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 03:22:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 53FE55F800
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:22:58 +0000 (UTC)
X-FDA: 84580114836.18.AA5E6BA
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf24.hostedemail.com (Postfix) with ESMTP id 194AD180005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:22:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774336976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WJS3NF/M4WPgBRzxGIiV9Ja4QEpGtBwod0o+PxQX9x0=;
	b=AbPo0mtDFj4pFAm6XnmLsL9qu+Lt/rtIw9yX/yWK70zBuerpfkrWx4jDiaIGc8ToUgG9g3
	gxOpYqo6+8a0KvVphEa/CczXf42GFjmHsiV3hBSeclRhy9KbXqT51w9yT1xcyPe/GFtZXu
	Rdwpq8y/5d9VVqs1vsxigMUmZ4I2YbY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774336976; a=rsa-sha256;
	cv=none;
	b=TXP765c16Zy45V5ATcF1V18f/D4Xz5rTSvoSo6M1Mp+Ijz69l7BFVOxMcjWv75nfxZMsM7
	jKVbPISAPjuatnR31t2X7av7QF0z3e/awUBqXG8sHeQRtUZK4iRiY72n0SBgz5TTP++mMk
	WHnAB3P9KrbAr/Wp2AXryLVRo+Vz62A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fg1h040znzKHMLn
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:22:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 55AFE4058C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:22:45 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgAX8UvDO8JpUawyCA--.57253S2;
	Tue, 24 Mar 2026 15:22:45 +0800 (CST)
Message-ID: <0427249d-c6c7-477a-aeff-e007198fcf45@huaweicloud.com>
Date: Tue, 24 Mar 2026 15:22:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] mm/mglru: scan and count the exact number of folios
To: Kairui Song <ryncsn@gmail.com>, Axel Rasmussen <axelrasmussen@google.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>,
 Yu Zhao <yuzhao@google.com>, Zicheng Wang <wangzicheng@honor.com>,
 Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan
 <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <20260318-mglru-reclaim-v1-4-2c46f9eb0508@tencent.com>
 <CAJHvVcgi8m_O03+Grv7jPX8btaVvYuZxh8S6kLjALfREykToDw@mail.gmail.com>
 <CAMgjq7CjwdaQk66=61sNLR_21eaPZrFiai2foaTQNbZ3uxQmRw@mail.gmail.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <CAMgjq7CjwdaQk66=61sNLR_21eaPZrFiai2foaTQNbZ3uxQmRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAX8UvDO8JpUawyCA--.57253S2
X-Coremail-Antispam: 1UD129KBjvJXoWxtrW7Jr1xXr4DGF43Kr17KFg_yoW7Ww4fpF
	ZxKay2yFW8XrWagryvqr4Fkr1akrZ8tryxXFyxAw1ayFnIqFyfG3W3Kw1jkFWUur48CF10
	v3W7KF47u3WjqFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	s2-5UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: 194AD180005
X-Stat-Signature: n6syysohcruxi18b57ik7ui7mgrjopks
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774336970-773888
X-HE-Meta: U2FsdGVkX1/CkLiu/Oln+TpjvfcLmOKrETnERXzlM986B49eQoGyMTJ8XHSx1fcceNB2vUchS3oaUEFgwhw1lKoUgFS6z6bSWnLh8Pp1DiPvwVwCicgZCAdOAkZagdU2IEnXzgYh3roJGsWwyvl030O6PuPvBFAG5VubOQaiTEGptltSd6AOZbcXti8w/na9XjvnBq+AJcpfH4jAhjJ3WRBcYJa16uwzZ4LX9z5PxBOXtemztQYNyHoaQHW9Tidcn6ZOCX7CK/2mWrbSCv+pBy8/VBPjl3sFpXx1gT2n9QqONAouqRd4kaJb12LyQN2PnN6rgfPxy3R7rDC7J8PMsGWhgXib8Exis6e3BZhgO80m8Sk/mYn+nxDDxyee0G59YzG4jyadXqTBph7j0g1mCww5IPryhwzSHXQEj/UV4qYyjbnqWwuCPIfYkkuqAgvs7zxH7IeKJTRY1tNnb6+D7E0o4xLcDTUcSmLJTEq5YSthF5PhVKpgwAMbizJVGYEOJJARSnSqJcHxMpboOS3MWl/7SC6Xod04nrZezIb/3CCxnCDZ2xOc4+w/lc7QwwxErAl4bS+U1HbE8hsgF2FyIGpSJfX+WztewHLlD8ASdAI+fhhJyjDLL0aqMC6EvbHatzWiZOCiVVod82BDmU+N5eWh9Wn+DfYS5+HMpFjr1PqrPIYmS10fp+1q759dRpQIgLcUjXLYJnO5wHlJgmsLQmuVUVOuFOn16Ze3jrr9BDhNd0uwFbztB/6QLXSCAzujOzmL4E7FVkVgCsQvLRz6iVwIGu2NZvyrVcLAldyeWQWhGBFmtj7dxz4TiBekTKpxM6hQNpHN85b2sLNzHVXKtLmQEbQ6AQLoKhIIYaX0DDnmFXg0EdAiLRQSRhidH2j1V2Mc+nnJtzIMPIgzxEbsYm4rKlB/2BaAUKPZ/KeTjV+oQajUcdKtqMsQD3VDfaKBmzXCSeOtugGQmeCy3pU
 hAcbjkLF
 0UiWRCzy85kaVxINvNFD2b+3G3vchcoKRYUPh/bhSclBG82zWrQoQZ5U9DCmL04Dmd/u0RUk5I3KEXHTwafMn1sKbXyb97/TX7OKMtHDQRK0Mvz9/AfvURAnVPhh2HYbUtu7NZfJKGQcSDXyGF0Fi/Ji24QXwANLcVfmTYQeMWl00D0mBngghMn+crETlocmxIUSqXsVU1hQd8oCoed/Cf7m+TITF6aXM3Fq8dQnEYi9JH/yGFmnuWpg7OWRJs/QVdXFx0ASOVZd0xkPeOaxfazDd4M9WloVSTHo0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/23 0:20, Kairui Song wrote:
> On Sat, Mar 21, 2026 at 4:59 AM Axel Rasmussen <axelrasmussen@google.com> wrote:
>>
>> On Tue, Mar 17, 2026 at 12:11 PM Kairui Song via B4 Relay
>> <devnull+kasong.tencent.com@kernel.org> wrote:
>>>
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> Make the scan helpers return the exact number of folios being scanned
>>> or isolated. This should make the scan more accurate and easier to
>>> follow.
>>>
>>> Now there is no more need for special handling when there is no
>>> progress made. The old livelock prevention `(return isolated ||
>>> !remaining ? scanned : 0)` is replaced by the natural scan budget
>>> exhaustion in try_to_shrink_lruvec, and sort_folio moves ineligible
>>> folios to newer generations.
>>>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> ---
>>>  mm/vmscan.c | 27 +++++++++++----------------
>>>  1 file changed, 11 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index ed5b5f8dd3c7..4f4548ff3a17 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -4680,7 +4680,7 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
>>>
>>>  static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>>                        struct scan_control *sc, int type, int tier,
>>> -                      struct list_head *list)
>>> +                      struct list_head *list, int *isolatedp)
>>>  {
>>>         int i;
>>>         int gen;
>>> @@ -4750,11 +4750,9 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>>                                 type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>>>         if (type == LRU_GEN_FILE)
>>>                 sc->nr.file_taken += isolated;
>>> -       /*
>>> -        * There might not be eligible folios due to reclaim_idx. Check the
>>> -        * remaining to prevent livelock if it's not making progress.
>>> -        */
>>> -       return isolated || !remaining ? scanned : 0;
>>> +
>>> +       *isolatedp = isolated;
>>> +       return scanned;
>>>  }
>>>
>>>  static int get_tier_idx(struct lruvec *lruvec, int type)
>>> @@ -4819,23 +4817,24 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>>                           int *type_scanned, struct list_head *list)
>>>  {
>>>         int i;
>>> +       int scanned = 0;
>>> +       int isolated = 0;
>>>         int type = get_type_to_scan(lruvec, swappiness);
>>>
>>>         for_each_evictable_type(i, swappiness) {
>>> -               int scanned;
>>>                 int tier = get_tier_idx(lruvec, type);
>>>
>>>                 *type_scanned = type;
>>
>> I think this is problematic, now `isolate_folios` can scan a nonzero
>> amount of > 1 type of memory. Then the caller (`evict_folios`) calls
>> `trace_mm_vmscan_lru_shrink_inactive` with the total scanned amount,
>> with only the last type we scanned (misattributing part of the scan,
>> potentially). Not a "functional" issue, but it could mean confusing
>> data for anyone watching the tracepoint.
> 
> Thanks! Nice catch, I'll introduce another variable for the tracepoint
> then it should be fine.
> 
>>
>>
>>>
>>> -               scanned = scan_folios(nr_to_scan, lruvec, sc,
>>> -                                     type, tier, list);
>>> -               if (scanned)
>>> +               scanned += scan_folios(nr_to_scan, lruvec, sc,
>>> +                                     type, tier, list, &isolated);
>>> +               if (isolated)
>>>                         return scanned;
>>>
>>>                 type = !type;
>>>         }
>>>
>>> -       return 0;
>>> +       return scanned;
>>>  }
>>>
>>>  static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>> @@ -4852,7 +4851,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>>         struct reclaim_stat stat;
>>>         struct lru_gen_mm_walk *walk;
>>>         bool skip_retry = false;
>>> -       struct lru_gen_folio *lrugen = &lruvec->lrugen;
>>>         struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>>>         struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>>>
>>> @@ -4860,10 +4858,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>>
>>>         scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness, &type, &list);
>>>
>>> -       scanned += try_to_inc_min_seq(lruvec, swappiness);
>>> -
>>> -       if (evictable_min_seq(lrugen->min_seq, swappiness) + MIN_NR_GENS > lrugen->max_seq)
>>> -               scanned = 0;
>>> +       try_to_inc_min_seq(lruvec, swappiness);
>>
>> IIUC, this change is what introduces the issue patch 6 is trying to
>> resolve. Is it worth squashing patch 6 in to this one, so we don't
>> have this non-ideal intermediate state?
> 
> Well it's not, patch 6 is fixing an existing problem, see the cover
> letter about the OOM issue.
> 
> This part of changing is just cleanup the loop code. It looks really
> strange to me that increasing min_seq is considered as scanning one
> folio. Aborting the scan if there is only 2 gen kind of make sense but
> this doesn't seems the right place. These strange parts to avoid
> livelock can be dropped since we have an exact count of folios being
> scanned now. I'll add more words in the commit message.

This change confused me too.

IIUC, this change looks conceptually tied to patch 3. The following change means
that evict_folios should not be invoked if aging is needed. So the judge can be
dropped there, right?


```
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
...
+		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
+			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
+				need_rotate = true;
+			break;
+		}
```

-- 
Best regards,
Ridong


