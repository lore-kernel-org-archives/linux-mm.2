Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A2D4FF60EE
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 08:43:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3D3B6B0095; Tue, 31 Mar 2026 04:43:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEDA46B0096; Tue, 31 Mar 2026 04:43:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADC6C6B0098; Tue, 31 Mar 2026 04:43:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A2FD6B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:43:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7530BBF5C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:43:08 +0000 (UTC)
X-FDA: 84605718456.01.8735775
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf16.hostedemail.com (Postfix) with ESMTP id B7DB3180004
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:43:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=C4gfgKX4;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774946587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mI5mJe1g+g7JAmX+8ag1GACYSXlhR+QhbwoWJOhaL+k=;
	b=8Ox2SoE157TPwWL/5fFhqVIosdvdwkAR+alUaAfMfQo4xbPaIugA+AUFtvtK+LUeu//LV+
	W3ZK7cTZcgexGpqpRJmlJH52HerFGjkIkiNSUQZHNnubg+trBjJgwrmhkVsH5dXojUyU8u
	uoaKoC/RD/FwILmx6oI9NU+gwkc8cL4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=C4gfgKX4;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774946587; a=rsa-sha256;
	cv=none;
	b=GJ7cJF6mmUCXibsfWXdWNNGpTsFdJOUauO1N68b6VojBForGMX6L97OWhch2Sxy+G+Lwsm
	TWNGqzH1mfZamgSeSsl7pvpvBIEiJoZ0QJbUlvONmgzB5Cg1mVl6l/QHBUWD9tg9d95bXL
	c1wv8dKWfJNwSZkecMwo0bzc8OXHmvg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774946582; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mI5mJe1g+g7JAmX+8ag1GACYSXlhR+QhbwoWJOhaL+k=;
	b=C4gfgKX4J50CR6g+dLSGjpOc1GylHdSyvRL6jZs4mhNnIxhF4jGqXKvwGdqrrysqhic/s1Tpw8ilYQzrjnb8VBbhKfy0kniO7gJVSMhuryFVJywrV1zpZNtWmtUuiOWPsaccuvrp2DI2MSW2pQ5c4h5jS4zSrpfUCCiYmX/9R40=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0X03s4ZU_1774946580;
Received: from 30.74.144.129(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X03s4ZU_1774946580 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 31 Mar 2026 16:43:01 +0800
Message-ID: <d77d5c39-a1cb-46e7-b343-3a20ff8caf3b@linux.alibaba.com>
Date: Tue, 31 Mar 2026 16:42:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/12] mm/mglru: simplify and improve dirty writeback
 handling
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
 <20260329-mglru-reclaim-v2-8-b53a3678513c@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260329-mglru-reclaim-v2-8-b53a3678513c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B7DB3180004
X-Stat-Signature: cdyfrcpy8ttf4cncmx1yqrk53s4w89j4
X-Rspamd-Server: rspam06
X-HE-Tag: 1774946585-37239
X-HE-Meta: U2FsdGVkX18vvyeduDGQ0SFMDB+BQwjVl+l9GqColV1qUKEKSUfKSqDrlfPGtico/PI4PI/QGxbz/OjA8It/EfHb+exAFzqFwaJpbjyjX0+kA8Qx+OmG2eB/rlthYaxZ9d89YvCi1k5haRcka97LBTpfakjKz8vbHAfQ7m7yTFTEHvhgPET/sBH3bY4neXfeVWZs2wkMzvnN9CKT035vx5Nyp8KSbLeCu0SFYUzALATZmAr9UrJHBmgIRctNQiIHkkOT9UGcyXDrCuZ9gpBwUUeGrYidzvNdkd/P/xaZuwOyNA0pessI89TsRHiRb/TltIMQowgvKzI4Q016H++6lBtrkFy2knLNyE1/SZOMDUICkPfDejKQTidM4o+Hv+dw2Ly7rL31CpYUez89766e9QVZfOHieAr8rEkKyFYWbG/eIJrEW6LYDjQy8q78Bzgo60imRzLdKSucBGXHY1V9k1nKbynPzEsyera4GbjW3ZSLCasiFg/IfYBEQ4jRVC+F2rt6eFFfUUuSpi7PHJakBZ7VFcVTL5nXIAq9Nz464EMrl6Y3yemo1sc7uCxKRMb9VTLkoFHHT2u595y3L6tJTImA/PwPJxyklMHw/iYWG6yvh59btmpR2Yrq1Xqn3iehed5xxZ0vWzCKTBhB9PC/b8lxl/lqmms9MT2O8lFvC43TewQLY0x/SKcGI73j/gMnoFnycdyIV0isIIRm1UGWwQR9KSaDg900hr9iPjF/7sGLmb9k+Kdf9Uup2FPcECLDSVsmFO5SQwfeLkhg9uEJFNxZ5UMSIrMrdZVeTIOpwPLY9DeCY0qB17AdFhaBscaiMKwjldr1UTpJ3BYi4q/pBFInOh+jVnufs/qzwkwfStz97wgdHOWkb4guyF2y09E2GUFPggq7orGf6oAes8V+zAvu4I8eSHTvPyah2Mh9dmpwPpYpGgqAXzmT44xqU0sWJbE3EFTb1rVySwURcm9
 XdVtO9jd
 dbdn1p+saE8A87jv/yBjzr5vOdNp48miMSBD6hS+J5XObDcSSv0lTxF6NABNl55JQpcQwFyIa4je7VNpaHywAbdXkYx3NCcvqIvKgszOk5mdAGZCkuaxr9Mutmdx6xw5JIR8bjLPvUymovEhGGEjFNZ32bpVXme5HOuAvf2lOy4jK2VG7Vv6mg4X2SAixbAmG6PhSc0wRUd60mJpcLNQlELbCs7nbBZoXdAfb3LLSolKfOLyhn+LGtoqVYGQgsaol38V77KzX7NAFx32lSk2LK0NOaVno+l4aLoUdBh+XBo87ZLoXnX7M9sMLDJfV9U4TL4nA0x35qUJrzm1gFCUua4AD0GiO7ba9ET3sHDG4Ns9nl+Y7zOs8B2jNvgngtvGOQHQ3UUwmxFl01GcvUPTVoGyfzZRdAhyvUK6OZi6SHZalQIsmAoaIrbgGuqeLvqGFhV0w9NXCkf3ZZ+JZocj64K/rRC6G3FEX515H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/29/26 3:52 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The current handling of dirty writeback folios is not working well for
> file page heavy workloads: Dirty folios are protected and move to next
> gen upon isolation of getting throttled or reactivation upon pageout
> (shrink_folio_list).
> 
> This might help to reduce the LRU lock contention slightly, but as a
> result, the ping-pong effect of folios between head and tail of last two
> gens is serious as the shrinker will run into protected dirty writeback
> folios more frequently compared to activation. The dirty flush wakeup
> condition is also much more passive compared to active/inactive LRU.
> Active / inactve LRU wakes the flusher if one batch of folios passed to
> shrink_folio_list is unevictable due to under writeback, but MGLRU
> instead has to check this after the whole reclaim loop is done, and then
> count the isolation protection number compared to the total reclaim
> number.
> 
> And we previously saw OOM problems with it, too, which were fixed but
> still not perfect [1].
> 
> So instead, just drop the special handling for dirty writeback, just
> re-activate it like active / inactive LRU. And also move the dirty flush
> wake up check right after shrink_folio_list. This should improve both
> throttling and performance.
> 
> Test with YCSB workloadb showed a major performance improvement:
> 
> Before this series:
> Throughput(ops/sec): 61642.78008938203
> AverageLatency(us):  507.11127774145166
> pgpgin 158190589
> pgpgout 5880616
> workingset_refault 7262988
> 
> After this commit:
> Throughput(ops/sec): 80216.04855744806  (+30.1%, higher is better)
> AverageLatency(us):  388.17633477268913 (-23.5%, lower is better)
> pgpgin 101871227                        (-35.6%, lower is better)
> pgpgout 5770028
> workingset_refault 3418186              (-52.9%, lower is better)
> 
> The refault rate is ~50% lower, and throughput is ~30% higher, which
> is a huge gain. We also observed significant performance gain for
> other real-world workloads.
> 
> We were concerned that the dirty flush could cause more wear for SSD:
> that should not be the problem here, since the wakeup condition is when
> the dirty folios have been pushed to the tail of LRU, which indicates
> that memory pressure is so high that writeback is blocking the workload
> already.
> 
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Link: https://lore.kernel.org/linux-mm/20241026115714.1437435-1-jingxiangzeng.cas@gmail.com/ [1]
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   mm/vmscan.c | 57 ++++++++++++++++-----------------------------------------
>   1 file changed, 16 insertions(+), 41 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 8de5c8d5849e..17b5318fad39 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4583,7 +4583,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
>   		       int tier_idx)
>   {
>   	bool success;
> -	bool dirty, writeback;
>   	int gen = folio_lru_gen(folio);
>   	int type = folio_is_file_lru(folio);
>   	int zone = folio_zonenum(folio);
> @@ -4633,21 +4632,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
>   		return true;
>   	}
>   
> -	dirty = folio_test_dirty(folio);
> -	writeback = folio_test_writeback(folio);
> -	if (type == LRU_GEN_FILE && dirty) {
> -		sc->nr.file_taken += delta;
> -		if (!writeback)
> -			sc->nr.unqueued_dirty += delta;
> -	}
> -
> -	/* waiting for writeback */
> -	if (writeback || (type == LRU_GEN_FILE && dirty)) {
> -		gen = folio_inc_gen(lruvec, folio, true);
> -		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
> -		return true;
> -	}

I'm a bit concerned about the handling of dirty folios.

In the original logic, if we encounter a dirty folio, we increment its 
generation counter by 1 and move it to the *second oldest generation*.

However, with your patch, shrink_folio_list() will activate the dirty 
folio by calling folio_set_active(). Then, evict_folios() -> 
move_folios_to_lru() will put the dirty folio back into the MGLRU list.

But because the folio_test_active() is true for this dirty folio, the 
dirty folio will now be placed into the *second youngest generation* 
(see lru_gen_folio_seq()).

As a result, during the next eviction, these dirty folios won't be 
scanned again (because they are in the second youngest generation). 
Wouldn't this lead to a situation where the flusher cannot be woken up 
in time, making OOM more likely?

