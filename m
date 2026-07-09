Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56875C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 04:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F17AD6B0088; Thu,  9 Jul 2026 00:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEE466B008A; Thu,  9 Jul 2026 00:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2DB76B008C; Thu,  9 Jul 2026 00:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA5D66B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 00:17:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 31BE91C8125
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:17:26 +0000 (UTC)
X-FDA: 84967928892.01.1BE794E
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0227780002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:17:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=icLsN4oX;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783570644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UBqGUL0+KiK1FMBVGSLXqyXS9/Lja6xJ1/PzEqDDCFY=;
	b=DwpqXkTzk1AYwz22sXTfiM48rZsHuSPQaX2OOQu6uIeFHWB8GNJ0nb1bvbr87qpUDsPdnI
	tUrFI9kDTtM4kTQOQJQBODCjsvzaLXWVCClFfTVvvGuHQiHdxj8l1cJf+Dflx/Vh7qsiDs
	Pxz7wS+tlNNdRihV22byjdNlvetRVoc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783570644;
	b=oJwdaf6ng6/Rhj6TbC88HNP193T1pIOeTUtJ3VoHHkazrsADee9qQAC24HwwBOPgdu4Iqy
	tcJvsVI4wz0ivrDIaEOxGevPXYRxsTVSS2zO9IJhwiS7gPOpITrssBMSqq5SS/XeCH6j9H
	XebDnjPUMk/9JKwcLRTNOvHHgdPnazk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=icLsN4oX;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <e90d3476-01aa-4037-91b5-bc35394b488c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783570642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UBqGUL0+KiK1FMBVGSLXqyXS9/Lja6xJ1/PzEqDDCFY=;
	b=icLsN4oXxOuREtLzUD4RXdMBccXd3DogAuZu4P1fEGCT4JgDFQZq7H9tzLzb0F0iYq0bME
	bOQp8MNv4Xq5eO+wuHws9itPdkw19ohX6bpcS859IzbhmKMOrEMHmLCIGXPSamjlWfuvpY
	De4KCJBJwUMom/iyle/je2BeLnQsmEQ=
Date: Thu, 9 Jul 2026 12:17:10 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4] mm: mglru: fix stale batch updates after memcg
 reparenting
To: akpm@linux-foundation.org, david@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org,
 kasong@tencent.com, shakeel.butt@linux.dev, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 hannes@cmpxchg.org, harry@kernel.org, muchun.song@linux.dev,
 peiyang_he@smail.nju.edu.cn, mhocko@kernel.org, roman.gushchin@linux.dev,
 ljs@kernel.org
References: <20260701075251.56413-1-qi.zheng@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260701075251.56413-1-qi.zheng@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0227780002
X-Stat-Signature: 4pcc14weidwgj8f1e8ngj9ohboc6xyjk
X-HE-Tag: 1783570643-697997
X-HE-Meta: U2FsdGVkX19bKhtFO9zIzsaFl1wZz41gmFJa0xkSdOl1NK1SwWQlDc0+z0t4aExV9q5RFMzgWR2eYoRzhiyKOpMBHVv+8fXQANhJCetZqQ+MIWoObtH0TrtoPr5594M88ihhRHqBIvtSasxlleDZJBPe7HobA+PBEPSOcJrrvqf/Ww8SsOQE9iiwlzqhsEVzv3SIn1A91cJkJwelsuEONQHUnyOO137n1UedCsSZpewgSeeWFCxoc7un4TBN9bHXMVpiSnE5v6wnVHefxS7TRF/K2qW0r15DQYgLEk27h5DEqbqzXaU/Lk6wHWCV12B8k6+U58rvj6p13rqYv7UfFEvv1NQFRHKAKKC2DzfAejoMhVSU5l9BKxvip7PYqya7uX1fw/XBXGzuYZBv46dKaW37s3cHg5kfF+rA7EOwupkiNVIH6wYIunMWjSZhdKTVdTDrJnYi3JZygf5q/jS7qoQkiyoQ62L3q6aijTScY+uooCYcX10udJzNSnDA+kSH+oS6NVzDfSvodsE0GpwkSKlN19ywlZOovI8BBfDFAF6vlch1o7N80hAvzTDvQB6GJU/h37Rkrjm5XcXbEF5RT1cS7y9xRkpY+J7m1mU7LRHF8FL2/U6EEeGAHrkqje4cDjJNz3y8oy8Pe4riWBtwDYpw+8XChCE/8ryfbOSSMC5Byd8fKZ/JMOf4rSabOkOmaOb49W4j7S0RQ9MBDD8gUPsMoA1bQLOwG+P9SAWGjDfnz2o9eZnGs3XdsyAyCcWPuDEoWmLjuwtIQx/ZLJGPYYWDW/BGEkQLgg6s3vfXTG/maVtAtzH9puhCZ3gB/eplftA9Rndsg2tZBJDQTiimN61qeolCzr4hK1JPOKbw5XRRACh2GZgi6dEcSQ3bVu5Y3SlT3yhKpdLu6YLj1jXLJZUu3f+22GAhtMSGvjfmhSjSiEka+umuejk1bAK92pDEAx/wSy2ZTvx5i3Lb9ll
 OyWvcVPu
 V3329NC+xtGN0eTnxcRWMM2Ubk/liCWLq/UVg8Qq98edZxYHUbWSGPhuuX711cWrdBQzfCITdrruA2LT8Z9ztWK3zGT+RS1j/sExsH37+iDSfrencnO4x9uRwthwOLHlZwIxaFlXw8ZXNR1fAkeBaUM141uJA9PEpm7q1lwSu12cXTkNpIUD7jvY2pZmlHGHRTfkJwmPFhL5Q3faz+xZ0HFpCk6/ZR4dpPdZx8lsR1qt1E4gMfl+epsHUHOFelZzqR8F8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew and David,

Gentle ping.

Is this patch good to be applied?

Thanks,
Qi

On 7/1/26 3:52 PM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The mglru page table walker batches per-generation size deltas in
> walk->nr_pages while walking page tables without holding the lruvec lock.
> The reset_batch_size() later folds those deltas into walk->lruvec under
> the lruvec lock.
> 
> The page table walker can run concurrently with the memcg reparenting path
> as follows:
> 
> CPU0                           CPU1
> ====                           ====
> 
> walk_mm
> --> walk_page_range
>      --> update_batch_size
>          --> walk->nr_pages += delta
> 
>                                mem_cgroup_css_offline
>                                --> memcg_reparent_objcgs
>                                    --> lock lruvec
>                                        lru_gen_reparent_memcg
>                                        --> reparent child folios to parent
>                                        unlock lruvec
> 
>      lock lruvec
>      reset_batch_size
>      --> child lrugen->nr_pages += delta
> 
> This will trigger the following warning in lru_gen_exit_memcg():
> 
> 	VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
> 				   sizeof(lruvec->lrugen.nr_pages)));
> 
> And the user-visible impact of underestimated nr_pages in MGLRU was
> premature OOMs because MGLRU does not try to reclaim memory when nr_pages
> reaches zero, but there are still more pages.
> 
> To fix it, make reset_batch_size() check CSS_DYING under RCU before
> flushing the pending batch. A non-dying memcg keeps the original lruvec
> stable against RCU-delayed offlining; a dying memcg redirects the deltas
> to the first non-dying ancestor.
> 
> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
> Changes in v4:
>   - re-implement lock_batch_lruvec() in a simpler way
>     (suggested by Johannes and Harry)
>   - collect Reviewed-by
>   - rebase onto the next-20260630
> 

