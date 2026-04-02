Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 493A01112274
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 02:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 933A16B0088; Wed,  1 Apr 2026 22:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4566B0089; Wed,  1 Apr 2026 22:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FA416B008A; Wed,  1 Apr 2026 22:51:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6BFC26B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 22:51:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 116FFE068D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:51:53 +0000 (UTC)
X-FDA: 84612090906.22.8C62F40
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id 38CE81A0008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:51:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RPGZDBq2;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775098310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O6TOWg+Xh5sI9yRDwt9IDvK3x1ZitgasY/GSlaC7Tuw=;
	b=ET/wPCkV3gvR7OeFtJs6YlT5oRtdiCLi9+Qw1fXh0NoNTq0fW2S3RgtMCgJ8DRjA0nz8tg
	GKXCaWJ89lTH4SLsiDn13hiHLijHV1KKkRrPiQtgeU0at32Usn1aEUsnLA05gVgX5w186m
	Jh8MptRpfEf8MJKwsaVzozKfigaYOWo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RPGZDBq2;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775098310; a=rsa-sha256;
	cv=none;
	b=aMD9gbdUPvKVb/HY0d4TBQSO7OtrXlMC5iTrM5evbcQnIubFBqzV7Fb+PlNIE/8Bm1V47/
	/dysPDZiA36qpmCknebWOzKTLFD6/WPpSb+wdo8Wpj8j4V8smCFepZq8bbkv1h+Qsuhm6q
	nocPQ5goKLony6UxzZR8xPEoyuxIvak=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775098305; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=O6TOWg+Xh5sI9yRDwt9IDvK3x1ZitgasY/GSlaC7Tuw=;
	b=RPGZDBq2qdefQLpg+OZxgegxatDEKtKZ6bcgd7CBIbUza67fMPhr7J36K9F0wNh+nSKN4j8d9S7xNeLPpz4idkU5FpDv/DG+abiqWrdEh5Z7NNwX9hhtKeKsSAmneOu0GPpCgkx7U+oqiDCjuVMQPjm7huWDQph0wfzpxZvsFBc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X0FcMEl_1775098302;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X0FcMEl_1775098302 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 02 Apr 2026 10:51:43 +0800
Message-ID: <0498d924-d76a-4d82-8767-e6297442967a@linux.alibaba.com>
Date: Thu, 2 Apr 2026 10:51:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: vmscan: fix dirty folios throttling on cgroup v1 for
 MGLRU
To: Kairui Song <ryncsn@gmail.com>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org,
 mhocko@kernel.org, zhengqi.arch@bytedance.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, ljs@kernel.org, baohua@kernel.org,
 kasong@tencent.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Jingxiang Zeng <linuszeng@tencent.com>
References: <3445af0f09e8ca945492e052e82594f8c4f2e2f6.1774606060.git.baolin.wang@linux.alibaba.com>
 <ac18iLvF-nNtxk1-@linux.dev> <ac3Pqq2WrGTJZLB_@KASONG-MC4>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <ac3Pqq2WrGTJZLB_@KASONG-MC4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 38CE81A0008
X-Stat-Signature: idnh13egf7qbkxj6qdj1kc7h9xc874gt
X-Rspamd-Server: rspam06
X-HE-Tag: 1775098308-654879
X-HE-Meta: U2FsdGVkX1/BcHEtT0JTP1YZCPN79cCAgt6Y6NDZQMcNAWm7ydJN6ilK120QQRAij9Qw/9NnF1RoC4Eo4SNKHGjZ4Kb0SanzlsS3fPYvuClDgvXY7PsgEbWObPKoKX+6UzAY33ibVgSMtBwfkXzuZZMnqSKsrN0KfjCvsWZXzTcrwP250hdcuV9/KXUtPaFA3bzLvJjomAs+HGXcwCaJ1PprK+Cd+bzeMw/83BVeRrAkdU7XsJir7bxNFy1GEIyBlB5SqBVW9m0Csza9t3PyRQ3XvPfHIJB5IfKqQLYDDvmvPRoh/OCrMb0mXFU1IKo7Gm7qsJCZB0qbr6ahacsgzsA2eUKWc7sR2p2QvO7geXPBiRQZthCOqiv1hM3XUMHUJSHjUntXrWWOWMpQ0PeK8kgex+NKbrFHLFiFv+bGA11Bk4cQgp+BcHTKqpzTL5j760idQqkhGEdmPJBu5lxx4nYY2yZOPbm+o2hSkrpzqCePmSVuFB/zGPK/h8pIuSQLwaWKLy7tAkkdY161uzYkblNv8ROVl2+2P/QPyju2HHC2d+7odSmqM7X2Me/vq+G+azjXHfEBdfAcHazE/ELUKz8A3t5kWg+s9zQmHTcH+o3RPizV+V9dQLzPj0C3J05YtY+l+ezmDFFqtUaCpEVf18u8AVcVWoy7lRkybY8rEC2W9bNkT/Nzq3iyF2aR0rOIYOjfBBJHhlehQ1fZGIKBLU0cVQQV7AtUItCqEEyi8gTBeLrpnvAepBp5hzn4DpAHgQqKylAZx7wLTFsY6kPfu/U5CeF9ch5H6s/pgEy+oCoZt7KNmjoY5Ky11cmLAea4Fq3cLudHodxTRnwvIrQmRHHg1qSc7Mr4JSZzjvmszNWP00OdDSi8IpP3jrOR/AGESkcnYSZTbmS7I5TFgDiQeB8TptqpqHvmzdi4yVIGem89jL1pRW8x1MckjzdYnTLH8QMbM8bzQjmaeZMhpSG
 Jz1vTpPV
 vzveqaTF2qeGZVW6ioi9f+d8g7fWVHZwnRNlXLNHX2hQd5G8+vtWyDTNcFI4NpKEW8FKQVlexYm/MmCY1XDTf0IX4g5LbcXtdnldaz3L71oCyL+sMHr0tbrLiKGhovoNWLY/8u2wITdCCH/QThfcGQ2aCpyIzfEGrllXGyGHC0EOLwyVT11D+71LHVLO2pi1KV9kLxNut+asOSWoFHDwuxHD9boHoiblErDICBxz/v0WM/aGKkqaUKp7yh/hqzffslMiC66bgHo10IS0/Xg+GfvDaR5XxkUH4J+CaI3K7vUoUU1s2HZCksgDUFXFayTc3VkvoeGCg5G4YopcHaoQHdSyTYMYdTTGpW1u//LCw8ec6dVOIHhGgE8SPFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/2/26 10:44 AM, Kairui Song wrote:
> On Wed, Apr 01, 2026 at 01:32:40PM +0800, Shakeel Butt wrote:
>> On Fri, Mar 27, 2026 at 06:21:08PM +0800, Baolin Wang wrote:
>>> The balance_dirty_pages() won't do the dirty folios throttling on cgroupv1.
>>> See commit 9badce000e2c ("cgroup, writeback: don't enable cgroup writeback
>>> on traditional hierarchies").
>>>
>>> Moreover, after commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no
>>> longer attempt to write back filesystem folios through reclaim.
>>>
>>> On large memory systems, the flusher may not be able to write back quickly
>>> enough. Consequently, MGLRU will encounter many folios that are already
>>> under writeback. Since we cannot reclaim these dirty folios, the system
>>> may run out of memory and trigger the OOM killer.
>>>
>>> Hence, for cgroup v1, let's throttle reclaim after waking up the flusher,
>>> which is similar to commit 81a70c21d917 ("mm/cgroup/reclaim: fix dirty
>>> pages throttling on cgroup v1"), to avoid unnecessary OOM.
>>>
>>> The following test program can easily reproduce the OOM issue. With this patch
>>> applied, the test passes successfully.
>>>
>>> $mkdir /sys/fs/cgroup/memory/test
>>> $echo 256M > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
>>> $echo $$ > /sys/fs/cgroup/memory/test/cgroup.procs
>>> $dd if=/dev/zero of=/mnt/data.bin bs=1M count=800
>>>
>>> Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
>>> Reviewed-by: Barry Song <baohua@kernel.org>
>>> Reviewed-by: Kairui Song <kasong@tencent.com>
>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> ---
>>> Changes from RFC:
>>>   - Add the Fixes tag.
>>>   - Add reviewed tag from Barry and Kairui. Thanks.
>>> ---
>>>   mm/vmscan.c | 17 ++++++++++++++++-
>>>   1 file changed, 16 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 46657d2cef42..b5fdad1444af 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -5036,9 +5036,24 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>>>   	 * If too many file cache in the coldest generation can't be evicted
>>>   	 * due to being dirty, wake up the flusher.
>>>   	 */
>>> -	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken)
>>> +	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken) {
>>> +		struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>>> +
>>>   		wakeup_flusher_threads(WB_REASON_VMSCAN);
>>>   
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
>>
>> This seems fine but note that this throttling is not really the same as the
>> throttling happening for traditional LRU. In traditional LRU, the kernel may
>> throttle much more due to throttling check happening at each batch within
>> shrink_inactive_list() while here the check is happening after full scan for the
>> given memcg's lruvec. So, throttling can be much more aggressive for traditional
>> LRU.
> 
> Right, I think Baolin's fix is great, but to improve the whole trottling
> mechanism we need some rework for MGLRU, currently I posted another
> series for this.

Agree. As both Shakeel and Johannes mentioned, I think we still need to 
unify the throttling in shrink_node(). That said, Kairui’s series is 
much improved over before and I haven’t observed any premature OOM 
issues so far from my testing.

>> This is v1 only and I don't care much but what is stopping you from moving away
>> from v1?
> 
> For example memsw?
> 
> https://lore.kernel.org/linux-mm/q2x4drxpjbxcxgns6bjp446ynsxgl32ckcljqcol7posds4nit@3n3tjq35anvb/
> 
> I remember Jingxiang's plan is to improve the page counter first.

Additionally, we still have some existing users on cgroup v1, and they 
will need some time to migrate to cgroup v2.

