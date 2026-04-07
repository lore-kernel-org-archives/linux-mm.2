Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92E89FB5183
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 02:53:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3ABD6B0088; Mon,  6 Apr 2026 22:53:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC4F06B0089; Mon,  6 Apr 2026 22:53:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDAE36B008A; Mon,  6 Apr 2026 22:53:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB27E6B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 22:53:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 205D61401C2
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:53:02 +0000 (UTC)
X-FDA: 84630237804.16.3D4889F
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8C11114000F
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:52:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775530380; a=rsa-sha256;
	cv=none;
	b=JKLsX+0hAx9Sbyx1HlfDIRVeYFgCHM98CiblPRnV55/sP41XgmpWh1/Mqq6is51T1/vku0
	rcjOMZHajrMkeOJGRC/KXC//X5dGnyeMbhRgGJql/R5dcfaZh7PqKHvB7u/tWhEqfO19tN
	hLPzKdKTzGaW3KjeC+nwVXlZbUQpjrk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775530380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z4+aE9PlHyYjv32xuRS+4ibAhGyjjSjYhz3cTIiD6R8=;
	b=PBLmYL1CVmcIJvHFQK36v0YNIXjbD1buh9L4xweooIM1NHNqafLp9bYM8EpGQzYegUFWbl
	Is5VQbhHtB5GtzjCYHtAPFZ+uvVaTr516TjIi0t3Nq1O/kEeyff8iJM5LD3DPkB1zhBK/D
	AgZ8gz/r45ot2HrW9DSLpNyxxmCrxAo=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fqW2D2ZZ4zYQtkt
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:52:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1C82C40561
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:52:52 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgAX8UuAcdRp6APJDg--.65434S2;
	Tue, 07 Apr 2026 10:52:50 +0800 (CST)
Message-ID: <f548cc08-6879-45af-982b-7291f4bf0501@huaweicloud.com>
Date: Tue, 7 Apr 2026 10:52:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/12] mm/mglru: simplify and improve dirty writeback
 handling
To: Barry Song <baohua@kernel.org>, Kairui Song <ryncsn@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, kasong@tencent.com,
 linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 David Stevens <stevensd@google.com>, Leno Hou <lenohou@gmail.com>,
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>,
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org,
 Qi Zheng <qi.zheng@linux.dev>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-8-b53a3678513c@tencent.com>
 <d77d5c39-a1cb-46e7-b343-3a20ff8caf3b@linux.alibaba.com>
 <acuNtuf-mv3KJJdn@KASONG-MC4>
 <CAGsJ_4xQvcDf5hTHa3M74R3xgjGRcfEa4-mrrpyLT7yaRZJ-hQ@mail.gmail.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <CAGsJ_4xQvcDf5hTHa3M74R3xgjGRcfEa4-mrrpyLT7yaRZJ-hQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAX8UuAcdRp6APJDg--.65434S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Gr1xur4Duw45XryxGF18uFg_yoW7KryxpF
	WfKFnFyF4kXr13trnIqr15K34ay3yxKF45XFy3JFy7tF9I9F1kKFyjkw48uFy3Ar98Gry0
	vr4jqFy3W3WDAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Rspamd-Queue-Id: 8C11114000F
X-Stat-Signature: us31w8s9djzbqpsog9kmgdzapy4n894o
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775530377-828735
X-HE-Meta: U2FsdGVkX1/R7wrQ+5tiRGI4sBV/6L1CK8sYHecUUkRpPZDlw+C36oi9NVpeNaYrdBunQU1MuO0Kj9Lcx4tIUUzyxlkpR72cdeke5hf5nsBK/XaHreQFEYKgZUR9k/vLrPFXYnyGalbWi/aAlIVP0WlMYw9/lDzApblJOR7u/ysE1XdSgzqso26I+uzYGfqLeK2c07/tu9eBVbnwYjF+KTWZgWMF1GE7HdFsw8i7DxgvaSl9ob0C+fD46f+BnJWvHIxWxvLZ6uAlgjAr6KcncgHzsTUEPFKACSZYQkNrdgrYUmkqNUDR1c6lMrkJFWFYQRZQJSAtNImj823tc66KXr5wJArWNqLH7sA7c9qTMaKfAuKT+gtN8rmJMEyP9xdw3rmU7EUZbtRACCSRzC7CkDICv2bKKeylJ5ImuhSirYK2YfaBWF1fa2yQEATTocOKfA0CVt0F5ENqidF+5CjgayPy9yr0xde7bKLfGuzdQ9lqKOJxl5wK94AoxyafRWLUiMFGKBza0OunKE8wfAEWdjLTAUToC6VPSa7FJce0Nlc1bXEeZ6DcNN1EldOOT+YZ6hD7tRXXbIIEZKUD7oudp+6Vg/oHZVIAxJuyeLmByWL266+HBeAWPsZviNQnZjIydmQsd7no6sehZVhFlnswo2T6NVVq8zXxRaD+l3cQv7ivew5gUxR83i9XGrkqPNcQ9MtRln5qqiI3ljrMb8f/Uv7MYU+7NJK0VzdFPV73KgzchFnG4+0PQIFsMwFyR/y3is3ApFl41NyNnlWgiT12MAf6wIkIVngeBhTHpF2g+mB+4zA6E/riOFuwj67ZOhQeMblX5jf3j7vSQvwecDAQyEZ4BsDKUJVsQZq9ksEXs1mkB93PjMXtTBXpsmYcJJwV45sPyfxfKKdvspGGI+b5et0YcM/M8TnLV4UA3pTSD1wXsPsRVYHvRuMEGC9TrTSFVBS6nQ+dSfnU6HTLdE5
 BIzu60YJ
 +FuaydPMfGKLWPx//VuWrNs+MDTbasBnALJX8pc+mHu07lZHjgLi7AR+Vzwd9FLFy9BSCw0u/1rCWfDexBSUOcbj0LUZS+IY+8M+EaSfa5i8aBQsqtZA7vih7AqeORTg2L5kBZ8DKBAFSPFmcnMpkoG164Z5N5MaOEm8AkLvNYMVAzz1zykG+bBYfjVuPDNzqn+LdQ85KQQS8SqBWFj5gr7RcbE6CByQmJVJmk1heUSvA8xoAalVG669dZa/pQ+CxKabp81uFdS9/gsHdw5kUmOfk6/Gzltc/P3XQ94ji413FwjeSOCoHz8KGrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/2 8:11, Barry Song wrote:
> On Tue, Mar 31, 2026 at 5:18 PM Kairui Song <ryncsn@gmail.com> wrote:
>>
>> On Tue, Mar 31, 2026 at 04:42:59PM +0800, Baolin Wang wrote:
>>>
>>>
>>> On 3/29/26 3:52 AM, Kairui Song via B4 Relay wrote:
>>>> From: Kairui Song <kasong@tencent.com>
>>>>
>>>> The current handling of dirty writeback folios is not working well for
>>>> file page heavy workloads: Dirty folios are protected and move to next
>>>> gen upon isolation of getting throttled or reactivation upon pageout
>>>> (shrink_folio_list).
>>>>
>>>> This might help to reduce the LRU lock contention slightly, but as a
>>>> result, the ping-pong effect of folios between head and tail of last two
>>>> gens is serious as the shrinker will run into protected dirty writeback
>>>> folios more frequently compared to activation. The dirty flush wakeup
>>>> condition is also much more passive compared to active/inactive LRU.
>>>> Active / inactve LRU wakes the flusher if one batch of folios passed to
>>>> shrink_folio_list is unevictable due to under writeback, but MGLRU
>>>> instead has to check this after the whole reclaim loop is done, and then
>>>> count the isolation protection number compared to the total reclaim
>>>> number.
>>>>
>>>> And we previously saw OOM problems with it, too, which were fixed but
>>>> still not perfect [1].
>>>>
>>>> So instead, just drop the special handling for dirty writeback, just
>>>> re-activate it like active / inactive LRU. And also move the dirty flush
>>>> wake up check right after shrink_folio_list. This should improve both
>>>> throttling and performance.
>>>>
>>>> Test with YCSB workloadb showed a major performance improvement:
>>>>
>>>> Before this series:
>>>> Throughput(ops/sec): 61642.78008938203
>>>> AverageLatency(us):  507.11127774145166
>>>> pgpgin 158190589
>>>> pgpgout 5880616
>>>> workingset_refault 7262988
>>>>
>>>> After this commit:
>>>> Throughput(ops/sec): 80216.04855744806  (+30.1%, higher is better)
>>>> AverageLatency(us):  388.17633477268913 (-23.5%, lower is better)
>>>> pgpgin 101871227                        (-35.6%, lower is better)
>>>> pgpgout 5770028
>>>> workingset_refault 3418186              (-52.9%, lower is better)
>>>>
>>>> The refault rate is ~50% lower, and throughput is ~30% higher, which
>>>> is a huge gain. We also observed significant performance gain for
>>>> other real-world workloads.
>>>>
>>>> We were concerned that the dirty flush could cause more wear for SSD:
>>>> that should not be the problem here, since the wakeup condition is when
>>>> the dirty folios have been pushed to the tail of LRU, which indicates
>>>> that memory pressure is so high that writeback is blocking the workload
>>>> already.
>>>>
>>>> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
>>>> Link: https://lore.kernel.org/linux-mm/20241026115714.1437435-1-jingxiangzeng.cas@gmail.com/ [1]
>>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>>> ---
>>>>   mm/vmscan.c | 57 ++++++++++++++++-----------------------------------------
>>>>   1 file changed, 16 insertions(+), 41 deletions(-)
>>>>
>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>> index 8de5c8d5849e..17b5318fad39 100644
>>>> --- a/mm/vmscan.c
>>>> +++ b/mm/vmscan.c
>>>> @@ -4583,7 +4583,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
>>>>                    int tier_idx)
>>>>   {
>>>>     bool success;
>>>> -   bool dirty, writeback;
>>>>     int gen = folio_lru_gen(folio);
>>>>     int type = folio_is_file_lru(folio);
>>>>     int zone = folio_zonenum(folio);
>>>> @@ -4633,21 +4632,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
>>>>             return true;
>>>>     }
>>>> -   dirty = folio_test_dirty(folio);
>>>> -   writeback = folio_test_writeback(folio);
>>>> -   if (type == LRU_GEN_FILE && dirty) {
>>>> -           sc->nr.file_taken += delta;
>>>> -           if (!writeback)
>>>> -                   sc->nr.unqueued_dirty += delta;
>>>> -   }
>>>> -
>>>> -   /* waiting for writeback */
>>>> -   if (writeback || (type == LRU_GEN_FILE && dirty)) {
>>>> -           gen = folio_inc_gen(lruvec, folio, true);
>>>> -           list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
>>>> -           return true;
>>>> -   }
>>>
>>> I'm a bit concerned about the handling of dirty folios.
>>>
>>> In the original logic, if we encounter a dirty folio, we increment its
>>> generation counter by 1 and move it to the *second oldest generation*.
>>>
>>> However, with your patch, shrink_folio_list() will activate the dirty folio
>>> by calling folio_set_active(). Then, evict_folios() -> move_folios_to_lru()
>>> will put the dirty folio back into the MGLRU list.
>>>
>>> But because the folio_test_active() is true for this dirty folio, the dirty
>>> folio will now be placed into the *second youngest generation* (see
>>> lru_gen_folio_seq()).
>>
>> Yeah, and that's exactly what we want. Or else, these folios will
>> stay at oldest gen, following scan will keep seeing them and hence
>> keep bouncing these folios again and again to a younger gen since
>> they are not reclaimable.
>>
>> The writeback callback (folio_rotate_reclaimable) will move them
>> back to tail once they are actually reclaimable. So we are not
>> losing any ability to reclaim them. Am I missing anything?
>>
> 
> This makes sense to me. As long as folio_rotate_reclaimable()
> exists, we can move those folios back to the tail once they are
> clean and ready for reclaim.
> 
> This reminds me of Ridong's patch, which tried to emulate MGLRU's
> behavior by 'rotating' folios whose IO completed during isolate,
> and thus missed folio_rotate_reclaimable() in the active/inactive
> LRUs[1]. Not sure if that patch has managed to land since v7.
> 

Not yet.

I checked and didn't find Kirill's series "[PATCH 0/8] mm: Remove PG_reclaim"
merged into master either.

I've rerun my original test case and confirmed that the issue can still be
reproduced.

-- 
Best regards,
Ridong


