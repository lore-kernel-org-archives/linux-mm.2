Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E53D4FF60F7
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ADF26B0096; Tue, 31 Mar 2026 05:36:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 537CF6B009B; Tue, 31 Mar 2026 05:36:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 427076B009D; Tue, 31 Mar 2026 05:36:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2CE866B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:36:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DA9E31B91B1
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:36:34 +0000 (UTC)
X-FDA: 84605853108.09.613CD5A
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf14.hostedemail.com (Postfix) with ESMTP id B39C0100005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:36:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LFGC0Em8;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774949793; a=rsa-sha256;
	cv=none;
	b=ssEHmkxcFrQC5D7NkTKD57gNS9uWaVFA2bLQwSBoKcKQsiTkzb4DBZGM5tta18/SHYB4aI
	R1S6khZJ8tuKsS7os8sGJXs0eJFReW+RlkHiSfsIJ2WCTwiNXDmtNO2jE3FryFTy8k8F0z
	JbOar0sk+I226osCGrOEfj6P8wNbMVE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LFGC0Em8;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774949793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VkJVBs8ELvWsSuKQ+1IMOp2IRxZTSWkSwM2U/2pFHug=;
	b=GXMC96wUbgd7Az/cb2yjTQGn8BNRIJ1aFvz9qPNCG5eqC5vG0ww4k6pCM8xo6PM2tF15vx
	UvsR4TZYXfX5bhP2waxtU0tXlpWVQuzqrpRxAykXuqSKW/PwsfuRc8oVvkahFpcy1AwQMQ
	CtHJihJ1f6Drlxx9jMWIgEy4VgeukWk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774949788; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=VkJVBs8ELvWsSuKQ+1IMOp2IRxZTSWkSwM2U/2pFHug=;
	b=LFGC0Em88J4ZYeYezeuBCXAPF8nG6mrryeUWu1qP/C1jJUFjU78kOkbklXgHxczXHI6nB9J6Tfhm1fI4+DNIdnETgPbuw2KEhBw5V2uRjNXG/J9fM3El+FhtuTd9YprpeoyJc5gfCHR+/9wnWaNJiFCE1sgHFgcjmzR6LJ8zW2c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R501e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---0X03yfwB_1774949786;
Received: from 30.74.144.129(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X03yfwB_1774949786 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 31 Mar 2026 17:36:27 +0800
Message-ID: <522f4898-78c3-453f-8367-29327e29290e@linux.alibaba.com>
Date: Tue, 31 Mar 2026 17:36:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/12] mm/vmscan: unify writeback reclaim statistic and
 throttling
To: Kairui Song <ryncsn@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>,
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>,
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org,
 Qi Zheng <qi.zheng@linux.dev>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-12-b53a3678513c@tencent.com>
 <052ae271-509c-42c3-877e-ac8822b314e5@linux.alibaba.com>
 <acuTMVSnGb0XRvTV@KASONG-MC4>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <acuTMVSnGb0XRvTV@KASONG-MC4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: df6nqkyxbn57eyw5sjqmu3axseowfwi3
X-Rspamd-Queue-Id: B39C0100005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774949791-40384
X-HE-Meta: U2FsdGVkX1+vtTImdSYkcTyoWvLGicyC28oJ3+4MgXxzNl+FXSTZknkYJRBuGSaaiLDObQJ9KCRmCk6Dtob26dswdZi1uIkj1leEsHuOncCBtzyFyjruDNGUrKGDRyF/CbkDIRx9740UdhlosTrjFdEzk935yIg4yCXvhmMjytXlTYo64iOXo+VTjphcFDUdR16LGmeDU+rRIe+jkkKT9EclYTohMuQfoCv7FqKuz+Mm748ESuFMHPdgLDXsBJ+5d+yWOMCgzeUsnqYpZ3lPNtZjxV4k14Y/xSe2rVQpWC2b7VsWngzEkWx4y5RYbka5S/eWKEnISmpINmyddGS8OK2fE6sF5f5NyQNOF/zmOM8polCQSsr15Uj2qruJHF7NpXHfA2EsjoovTI32qKUz6qVzdGvJRAY3fGlFFAJsIVC2n+GbUE/o6D0hJnHLXf+kwEw61ZkxaTsp5OVBNLUl2QlH6/gbST847i0hbT0STbsLUwxAmE49NeRydGEh4/MSdFos1paXw5Ax2KjdoODbo20tuOaEkmmGuqJ2Z/l9foyv11aNNanp9Ft2BhIY7ZR/mplf7Ln6rteJ9fva6u/fpo5uBADKB3GdCqUT7xO2egMIHnMLFQe3G9DzUiJ53VIOgm6uBnFLlBtimptFBa/dqOUmtCVKPDfWvbmhfbJtNElsIjzesk1oRy63ka69J6NHc48FcY0HSvqKFDxXlIHkzy9vHxXXwZTTotOEeU9MGQinshdcWcL6Bqa7+VsDrrGIPmN3BeHu4Y+Ul7SlLnP0OklA//Xxy4HOOvqDtia/69VgAw10psPu7TWk4Nj3mxDEkgz57vyevnd7KZDEXyxQy+Y2QC6EegeyMd6i6wW80rvC7UyUwUFlZWKyjLygo00KY0h28VeRc4XOI9WYf/UHK5r8wvijMgBTrx54r47LFBjssgI8TZgQ4fuLlZqnClkOogg6BTF1TiIRGSJ/Gei
 FELEmUVG
 mqa1HTktA6RW8j/iLqiTodchnHaQdTyguNrUBXvRHOtXRscm/Wpe/FXiAQ31PttXtv9MDMg28p+M2H+3EEvzPl61oqytg8IVeluzQEM+iUhSp9g6CVihiQgPnXIfYFHVj055n2seUOdmjjnRivjXlPimKBfU0mjGvMRiUxlq1jG97sKdIm3pqzqpEoIvJZp6VhyNiCFdCCIGsxkdFcKzauBIzuXPQEqMTKSIihUTBUKgSy6H2i1UR+WMbKGnOQe6cXRXUCtJ4IW2FwQ2rdG78wtoIKgtRM+npZX1dvGB3C9tqYKVzSYPH7rmMO0UwLmEI5EImHsNF9o+Wq39ZAKM0MeY0qVnABqg/DKrcu3lmsR3NVrS6vgp6i7R3+Q0O3Ix5FLq73LmlDW4yIcmoTtm/c8Yp1sUYBz7R6jyTWyRNtI5Jb5oR4clHeHyBGoYgFX8niXolrpzTDKhtkmk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/31/26 5:29 PM, Kairui Song wrote:
> On Tue, Mar 31, 2026 at 05:24:39PM +0800, Baolin Wang wrote:
>>
>>
>> On 3/29/26 3:52 AM, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> Currently MGLRU and non-MGLRU handle the reclaim statistic and
>>> writeback handling very differently, especially throttling.
>>> Basically MGLRU just ignored the throttling part.
>>>
>>> Let's just unify this part, use a helper to deduplicate the code
>>> so both setups will share the same behavior. Also remove the
>>> folio_clear_reclaim in isolate_folio which was actively invalidating
>>> the congestion control. PG_reclaim is now handled by shrink_folio_list,
>>> keeping it in isolate_folio is not helpful.
>>>
>>> Test using following reproducer using bash:
>>>
>>>     echo "Setup a slow device using dm delay"
>>>     dd if=/dev/zero of=/var/tmp/backing bs=1M count=2048
>>>     LOOP=$(losetup --show -f /var/tmp/backing)
>>>     mkfs.ext4 -q $LOOP
>>>     echo "0 $(blockdev --getsz $LOOP) delay $LOOP 0 0 $LOOP 0 1000" | \
>>>         dmsetup create slow_dev
>>>     mkdir -p /mnt/slow && mount /dev/mapper/slow_dev /mnt/slow
>>>
>>>     echo "Start writeback pressure"
>>>     sync && echo 3 > /proc/sys/vm/drop_caches
>>>     mkdir /sys/fs/cgroup/test_wb
>>>     echo 128M > /sys/fs/cgroup/test_wb/memory.max
>>>     (echo $BASHPID > /sys/fs/cgroup/test_wb/cgroup.procs && \
>>>         dd if=/dev/zero of=/mnt/slow/testfile bs=1M count=192)
>>>
>>>     echo "Clean up"
>>>     echo "0 $(blockdev --getsz $LOOP) error" | dmsetup load slow_dev
>>>     dmsetup resume slow_dev
>>>     umount -l /mnt/slow && sync
>>>     dmsetup remove slow_dev
>>>
>>> Before this commit, `dd` will get OOM killed immediately if
>>> MGLRU is enabled. Classic LRU is fine.
>>>
>>> After this commit, congestion control is now effective and no more
>>> spin on LRU or premature OOM.
>>>
>>> Stress test on other workloads also looking good.
>>>
>>> Suggested-by: Chen Ridong <chenridong@huaweicloud.com>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> ---
>>>    mm/vmscan.c | 93 +++++++++++++++++++++++++++----------------------------------
>>>    1 file changed, 41 insertions(+), 52 deletions(-)
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 1783da54ada1..83c8fdf8fdc4 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -1942,6 +1942,44 @@ static int current_may_throttle(void)
>>>    	return !(current->flags & PF_LOCAL_THROTTLE);
>>>    }
>>> +static void handle_reclaim_writeback(unsigned long nr_taken,
>>> +				     struct pglist_data *pgdat,
>>> +				     struct scan_control *sc,
>>> +				     struct reclaim_stat *stat)
>>> +{
>>> +	/*
>>> +	 * If dirty folios are scanned that are not queued for IO, it
>>> +	 * implies that flushers are not doing their job. This can
>>> +	 * happen when memory pressure pushes dirty folios to the end of
>>> +	 * the LRU before the dirty limits are breached and the dirty
>>> +	 * data has expired. It can also happen when the proportion of
>>> +	 * dirty folios grows not through writes but through memory
>>> +	 * pressure reclaiming all the clean cache. And in some cases,
>>> +	 * the flushers simply cannot keep up with the allocation
>>> +	 * rate. Nudge the flusher threads in case they are asleep.
>>> +	 */
>>> +	if (stat->nr_unqueued_dirty == nr_taken && nr_taken) {
>>> +		wakeup_flusher_threads(WB_REASON_VMSCAN);
>>> +		/*
>>> +		 * For cgroupv1 dirty throttling is achieved by waking up
>>> +		 * the kernel flusher here and later waiting on folios
>>> +		 * which are in writeback to finish (see shrink_folio_list()).
>>> +		 *
>>> +		 * Flusher may not be able to issue writeback quickly
>>> +		 * enough for cgroupv1 writeback throttling to work
>>> +		 * on a large system.
>>> +		 */
>>> +		if (!writeback_throttling_sane(sc))
>>> +			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
>>> +	}
>>> +
>>> +	sc->nr.dirty += stat->nr_dirty;
>>> +	sc->nr.congested += stat->nr_congested;
>>> +	sc->nr.writeback += stat->nr_writeback;
>>> +	sc->nr.immediate += stat->nr_immediate;
>>> +	sc->nr.taken += nr_taken;
>>> +}
>>> +
>>>    /*
>>>     * shrink_inactive_list() is a helper for shrink_node().  It returns the number
>>>     * of reclaimed pages
>>> @@ -2005,39 +2043,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>>>    	lruvec_lock_irq(lruvec);
>>>    	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
>>>    					nr_scanned - nr_reclaimed);
>>> -
>>> -	/*
>>> -	 * If dirty folios are scanned that are not queued for IO, it
>>> -	 * implies that flushers are not doing their job. This can
>>> -	 * happen when memory pressure pushes dirty folios to the end of
>>> -	 * the LRU before the dirty limits are breached and the dirty
>>> -	 * data has expired. It can also happen when the proportion of
>>> -	 * dirty folios grows not through writes but through memory
>>> -	 * pressure reclaiming all the clean cache. And in some cases,
>>> -	 * the flushers simply cannot keep up with the allocation
>>> -	 * rate. Nudge the flusher threads in case they are asleep.
>>> -	 */
>>> -	if (stat.nr_unqueued_dirty == nr_taken) {
>>> -		wakeup_flusher_threads(WB_REASON_VMSCAN);
>>> -		/*
>>> -		 * For cgroupv1 dirty throttling is achieved by waking up
>>> -		 * the kernel flusher here and later waiting on folios
>>> -		 * which are in writeback to finish (see shrink_folio_list()).
>>> -		 *
>>> -		 * Flusher may not be able to issue writeback quickly
>>> -		 * enough for cgroupv1 writeback throttling to work
>>> -		 * on a large system.
>>> -		 */
>>> -		if (!writeback_throttling_sane(sc))
>>> -			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
>>> -	}
>>> -
>>> -	sc->nr.dirty += stat.nr_dirty;
>>> -	sc->nr.congested += stat.nr_congested;
>>> -	sc->nr.writeback += stat.nr_writeback;
>>> -	sc->nr.immediate += stat.nr_immediate;
>>> -	sc->nr.taken += nr_taken;
>>> -
>>> +	handle_reclaim_writeback(nr_taken, pgdat, sc, &stat);
>>>    	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
>>>    			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
>>>    	return nr_reclaimed;
>>> @@ -4651,9 +4657,6 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
>>>    	if (!folio_test_referenced(folio))
>>>    		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
>>> -	/* for shrink_folio_list() */
>>> -	folio_clear_reclaim(folio);
>>
>> IMO, Moving this change into patch 8 would make more sense. Otherwise LGTM.
> 
> Thanks for the review! I made it a separate patch so we can better
> identify which part had the performance gain, and patch 8 can keep
> the review by. Patch 8 is still good without this, a few counters
> are updated with no user, kind of wasted but that's harmless.

I’m not referring to all the above changes. What I mean is that the 
'folio_clear_reclaim' removal should belong to patch 8. Since 
shrink_folio_list() in patch 8 will handle the writeback logic, 
folio_clear_reclaim() should also be removed in the same patch.

