Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D10C4C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 06:53:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A27DF6B0092; Fri, 24 Jul 2026 02:53:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6FE6B0095; Fri, 24 Jul 2026 02:53:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917876B0096; Fri, 24 Jul 2026 02:53:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67DCD6B0092
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:53:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E5D26802DE
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:53:57 +0000 (UTC)
X-FDA: 85022755314.28.DF3B31E
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7F91AA0005
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:53:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fKcoAGrr;
	spf=pass (imf15.hostedemail.com: domain of guopeng.zhang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784876036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=APONQVsPJkkQx8mNtrNVFM4P3UKPMmWHeB8nUygzPiE=;
	b=RNETKdMnwuRzNF8QaFTeEUvEiItcCo/WZ2RBAxiToxZUfDzLDDJCsDim3wpZxK1aYvKbkU
	i7Y4bpe9GN09VnTXqD+dyiosRIOrV9fVDPuFY8TP3KwoIFxOTRZyhqqfVQ/xIOH+EPyOqj
	DcONNLbGKlGYnD6TAim8f6zFj0AdzKk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fKcoAGrr;
	spf=pass (imf15.hostedemail.com: domain of guopeng.zhang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784876036;
	b=T1cFnIK0aVeAI0pKOnPMFXxDxfjbNI0q+BG5ZqtuuUZrx15HsaKWAAgl17D5bsmG6WQCcH
	OlzsMrL8qrUZC9rikkDktq6O3rrsl60cs8GelIXFhamWJjPI5U8DMFp3rL13zUh3hJJ57q
	+VeJ8k95yN6SMZxCdk+k5Ku8FgsAVz4=
Message-ID: <cf2df458-2b0e-46bd-9eea-f3c15265d90e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784876031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=APONQVsPJkkQx8mNtrNVFM4P3UKPMmWHeB8nUygzPiE=;
	b=fKcoAGrrAnA635Yh9d/uLCwMRNa9LD5bxnO4YgA2+uFrLRy0La+iXderjPvz4yoAv3efz8
	Z8yOoE74pSaM0nn1NfQT2Gr9E7SPCtWd1jupNsaGo0G/ZfD7GxHXuOCCRbxT3+WrZTma1T
	X+pi5BI/4WATlWg0CzclnMNkKhRpus0=
Date: Fri, 24 Jul 2026 14:53:29 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm: memcg: stop reclaim when a limit update is superseded
To: Tao Cui <cui.tao@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
 <da7f525e-077c-4fc2-99bf-04685b1d8225@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <da7f525e-077c-4fc2-99bf-04685b1d8225@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F91AA0005
X-Rspamd-Server: rspam01
X-Stat-Signature: jti34z7i7xpqo861ckihgcf1acseb9nm
X-HE-Tag: 1784876035-835927
X-HE-Meta: U2FsdGVkX19AXUnyPYQMKcVwyVy6s2bmeZZDuDhl7sC5wh2YZyA4tKdhxx3uiMC4Mf730SQK//3ZRuAAsbSUu5ptCZMckX3BuzLG/nKWakq2x88h0eVs25NquSyNDYj8mmZ4zT/JL9vc1mO+Ai9x+t3Q6dykwjMN2y1BnOaviJYfjhhtsS1mhlFQFXoji9vBq22c+7uF4xwXVGoWojKEKsGxlZglxYCFAnWkfwFSkJrYsCCWh7e7bAZmiqdNr+Z0evAS/xEHRmMSw2EIdEZ8BB1Lokno2ECQvoM1a0uGYGE606yB2tnebylJq+ZRKOmP/byckT78kDJXa7gwoUOZ4OYu4v0m4c1hqHX3hBclKS4izc3JnFTZ/Srr8yHdgJWxVdzgkANK1aXGxYin8InXuQT8Mj135o5zQvC3/BgjUqtsmzsfwgVpU+1MB/LmMuqP/jsCm4P2bf2fRSs3Wi4q5V6U+I+rYbi/Xs7KEH6olLGOUMTvanXpXDCU90V0ROD3NH8ZubPOxACWUpaW4MK12CPbV1JjUUHS8mmaXIljy+oKc8awC7XI2VDuesmJ3syh9R5yc7UA/pmUaiyKXa4LMvkOpSwbIAW4abjN+VZ5P7KJxshBlynusLD3COFdJWRM7vNKl1XrlLywUWgvO7seIyjvA7g4eIPXyoUgeshtp3cy7zSgmfCBryfOL5ywZYx3g/n0T4WOILegUIP+BaWmfI9ClHcal6yiU7zdISqGko0bgXNgmmT7mcHLd5SDyOkpgDiCCQcywbcrBmVJbUInzMs4eQCXLrijb9QLA+MSfKGTWo3rd+6Zzc/37vW4aQfpFM9esuZxeEA3fJJdXIGqA4ckpUCoPqPjlnolEMd6frjOysXwmpnK4G2NTh8TvM4aCF41ZAxeooAZw0vMStPqhebBuf+pCCVjpdTXXicLxOZK2saImXaQQTvWRgdSLnLC6EMX67mOcVrRhU5l62l
 ZlcG0JI6
 59vRadrbJZiPjTWqR394XYbMF/xqehNaHr1uSJ45j9b27E7O22cx5ue6bs35upjOvcn2egOHacyy8nUhsuYX8YgQzukQfoA5Bt8t4814SrqSgx34RjUgHokar58Gi5HIpws6Lh40m6VbU0Eh/47gnhUQoLfvZ3QRoVUMqAZYXYbB+sXe54+qyHpLanR/eawARsRcQ2vmKY+HiXQT+xx6kHyNxwAvjB7aknOYaYQaRlPOj4S8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/24 11:32, Tao Cui 写道:
> 
> 
> 在 2026/7/24 10:18, Guopeng Zhang 写道:
>> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
>>
>> kernfs serializes file operations only per open file, so separate open
>> files can update the same memory.high or memory.max file concurrently.
>> Both handlers store the new limit before synchronous reclaim, but
>> continue to use the writer's local target in the reclaim loop. If another
>> writer raises or removes the limit, the first writer can continue
>> reclaiming toward a stale target.
>>
>> For memory.max, this can leave the writer looping indefinitely once
>> reclaim retries are exhausted. The OOM path sees sufficient margin under
>> the current limit and returns true without killing, while the writer
>> still compares usage against its stale target and records another OOM
>> event.
>>
>> Check the current limit at the start of each reclaim iteration and stop
>> if it no longer matches the writer's target.
>>
> 
> Fix looks correct to me.
> 
> Acked-by: Tao Cui <cuitao@kylinos.cn>
> 
> Nit: the message lumps both paths together, but only memory.max loops
> indefinitely. memory.high has no OOM path, so it just spins
> MAX_RECLAIM_RETRIES times and breaks on its own. Worth a line to avoid
> conflating the severity.
> 
Hi,

Thanks for the review and Ack.

The message separates the two cases: the first paragraph describes the
stale-target reclaim behavior common to both, while the "For memory.max"
paragraph describes the OOM-based indefinite loop.

One detail is that memory.high is not limited to MAX_RECLAIM_RETRIES
iterations. The retry counter is decremented only when reclaim makes no
progress:

        if (!reclaimed && !nr_retries--)
                break;

If reclaim continues to make progress while pages are refaulted,
nr_retries is not decremented and the loop can still fail to converge.

Thanks,
Guopeng
>> Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")
>> Fixes: b6e6edcfa405 ("mm: memcontrol: reclaim and OOM kill when shrinking memory.max below usage")
>> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
>> ---
>> Reproducer:
>>
>> Populate a cgroup with anonymous memory and disable swapping. Lower
>> memory.max from one open file, then restore it to "max" through another
>> open file after the new limit becomes visible.
>>
>> Without the patch, the first writer remains blocked and repeatedly
>> increments the OOM event counter. With the patch, it returns normally.
>>
>>  mm/memcontrol.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 8319ad8c5c23..638bdc766616 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -4798,6 +4798,9 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
>>  		unsigned long nr_pages = page_counter_read(&memcg->memory);
>>  		unsigned long reclaimed;
>>  
>> +		if (high != READ_ONCE(memcg->memory.high))
>> +			break;
>> +
>>  		if (nr_pages <= high)
>>  			break;
>>  
>> @@ -4853,6 +4856,9 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
>>  	for (;;) {
>>  		unsigned long nr_pages = page_counter_read(&memcg->memory);
>>  
>> +		if (max != READ_ONCE(memcg->memory.max))
>> +			break;
>> +
>>  		if (nr_pages <= max)
>>  			break;
>>  
> 


