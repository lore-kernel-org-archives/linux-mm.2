Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAEF36082BCC
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gYelhsNC
Received: by kanga.kvack.org (Postfix)
	id 0BB826B05B0; Thu,  5 Nov 2026 14:37:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0944F6B05B1; Thu,  5 Nov 2026 14:37:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEB706B05BC; Thu,  5 Nov 2026 14:37:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CBF876B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:37:57 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69BE0A0BEC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:37:57 +0000 (UTC)
X-FDA: 85402075794.10.95EC33D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8FDAC120008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:37:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gYelhsNC;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793907475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0kaAxOY/SSspRWpSrBfn0a4T5P5meoIx1W2LCkWKZd4=;
	b=necnHOsks5Mw8ljwzSxSH6U2nCzg6526DT9aqS4F55ro3HLuP58QU0ojEpk7cDeIvegH0u
	rvh/iHnloZaBAn+vENYe+Ao5hBEG7ZOD+9/jd3WBh+v8SjLPXxbDiVLcexz+12j5EF8ryS
	zFrzfFcXRqytFKPa3KCe7nEpc553hdY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gYelhsNC;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793907475;
	b=5q5G8chYmTSCDf63LDnKmnRY+rdRpdOUTlnvlVs5hCoNFlWqYYWSQQx2rLvw01hgQjDypB
	4fth8sESCiVdzbF2cP1ivlKwJVdkOvfi96OK/dGY71uEc699XQwhNdMbUJ5UOa3qsy05f1
	3ZeAXpUyeW++kDXSALeCAUW+UDngXE8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C7C3440339;
	Thu,  5 Nov 2026 19:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CB41F0089F;
	Thu,  5 Nov 2026 19:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907474;
	bh=0kaAxOY/SSspRWpSrBfn0a4T5P5meoIx1W2LCkWKZd4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gYelhsNCbbHH6tgq4KIVZIkbdg848ntOab8f0VTwd75TgOhQg/VsXZrEc7NBXE+Hz
	 K9ArsxWRAadIeQXosxCRFVS5z/MGdhLHDXT+kGM7ZkcLijABInxRc0GFaJBXTIYkUb
	 9ntEf/NibOTdjSEfSTcQs5oKRFEANZjbBc8cEKZwyZJlQN0yZ0+36fPKuhEiH3EMRt
	 p9uzL2Ydg6CxWVIiOich5Im3z2U4fBMdl7AZheB840DZrHK8vDkcKRnzwpZ7KbF+Oy
	 zBzOK4tusC/B9KutOZ1GQLIqzylHfqcRNfdNTcYEflUr5px/EMULgKQNLYU4PFdGl7
	 gzrtYbsPGNysQ==
Message-ID: <6849a9c7-0e11-42f2-bd99-d7ae3d5b944a@kernel.org>
Date: Thu, 5 Nov 2026 20:37:46 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: move LRU size stat updates out of lru_lock in
 folio batches
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, yosry@kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, kasong@tencent.com, qi.zheng@linux.dev,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev,
 cgroups@vger.kernel.org, linux-mm@kvack.org
References: <20261029204157.117879-1-joannelkoong@gmail.com>
 <auPhT70GU-Zqe9Qy@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <auPhT70GU-Zqe9Qy@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1khaeh6jp3e15s3344nrok3w64tp8oxy
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8FDAC120008
X-HE-Tag: 1793907475-471882
X-HE-Meta: U2FsdGVkX196ANPnuuOzilP/Az7R8wSZLCeSAOs8eYAdFoTjGU+qn13SS7XC+dfx/yeLoIW7uls+8UzUSdUUfSQ6mvQmYhWGKA6IQJqVffqnlsY39VbHG9T8zcxrOSJex2mWj+yr6TDxeNiArfjN6P71dcGJGHgX4nRHGLDgu3XzF3Mu32jYrfQ4wPM20A0OUNddVX6n7INA6g9qSxzvqbUjgoziyQrCJ1jOYJe4JJKGLt+f7qPVhH3h18709PChNFbaGFiMf/UshqL+KpHn/ZLXgCh1v2PCVsvpcoNlGzeTmkj3Dc6qUqwT5wtPn4TvsosAvWZXdo2D5ic8JPmtnMi5EBF3jVyVbkdVyQ3BBgsKq/q1+elG9na7m8E6FFtWMKTc8zO9/VqGwt5tnNsK5mirTAWqv5us/CFfUIwLeg+vjb5OiRPmF+OMrkcfdlRt06Fdz9mcsBKVvvjTsUFnV7C4ad+ZhZ/u+IUcMP2WJUjStEIY1iWIWLyUshmQKcF76uQ7w+uWyMATpOLDYVxsrCZk6Voh/Ki/O06N5OJcX1cLMdzFieijNS3zid+jKYPvooau9zSCuGP8j+dT6oVc2S6I35x4JukCsW9eBd3qdeN5vT4aIbhoxrdS2+W9/JRCVl/x+ZdmHjg+mPtustj9evaV96OgQhpcquzEDIv3lcJ8pVNtgE19Jd0lWLpyPDoA7epr0jvofatbbVMpQSGMhomIvrOa5ubpSDvQT1olvG9xNTO/EsIER+vXohtAkUcUpPmJeZ6vvGQbdQiXMgvKfDQEE1FczaKxUVM+c/nm5l3yFU2mx3kiYz9R0QySvzRGOS+KS4pan/MSDC7KyaovBHOD0xNkE3TLSY6vtJneKkE8z4bl4fcbuLO593V71CLrA+vfHF4vlu3xDfRnO8Z9Ue0PgVV4vxXPw45R2yNqlGjEZbWEAGL86kD0KJT2Fo1JVG9e2Z/50vDdu1Bo19N
 CFiUg7+I
 WEC4s0Q2lqxla+FJ9h55X0iA/Cq+Ne1fj71qy3MiN1aMb/6f6JovOzT8Grx89Ol6QEQUGIThhZ5u+bbQESRxD8C6VPGOAsikmrcV3HrDE48ywZ0KUlifHWYvBFl11M7I11Vo2rxbiOafOhmtEHo85b37N49TUcgY1vdZdpNl6G5hwpmFfl9Ntxkd2+/hTCSS5W7HMeRX59bD0zoPzl640wWgHB2DQzDfnM1OW0G221bRJm+eluewRIELuN1a6eM6LgLwTae08wYV++ZHKwnoy4yoKnp8ktvbcxO2bgC+QuYnLHhf/JKLBMWxJfIEauhLwWh8ZAM8pyz2CKpzjZL2+ErGaP1jXQ9ukaaDv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/30/26 01:19, Shakeel Butt wrote:
> On Thu, Oct 29, 2026 at 01:41:57PM -0700, Joanne Koong wrote:
>> folio_batch_move_lru() and folios_put_refs() take the lruvec's lru_lock
>> once per batch, but they update the node and memcg lruvec stats for
>> every folio in the batch while holding the lock. Only the LRU lists and
>> the memcg lru_zone_size need lru_lock. Updating the stats while holding
>> the lru_lock is unnecessary, and they make up a large part of the
>> critical section, as seen in [1] where a change that added just a few
>> instructions to the memcg stat update path cost about 2% throughput
>> because the LRU stat updates run under lru_lock, and the overhead went
>> away once they were moved outside of the lock.
>>
>> With many threads faulting and freeing memory in a single memcg, about
>> half of all cycles are spent waiting for lru_lock, and the hold time of
>> the lru_lock directly limits throughput. A perf profile with 80 threads
>> faulting in and freeing shmem in a single memcg shows 52.8% of all
>> cycles spent spinning on lru_lock, split evenly between
>> folio_batch_move_lru() and folios_put_refs(). About 25% of the time
>> spent holding lru_lock in those two paths goes to the LRU stat updates,
>> mostly cache misses loading pn->memcg, pn->lruvec_stats_percpu and the
>> per-cpu counters. The stat updates are only 0.7% of all cycles, but they
>> lengthen the critical section that the other threads are waiting on.
>>
>> Accumulate the stat changes per LRU list while holding the lock instead,
>> and only apply them after dropping the lock (while still inside
>> the RCU read section that keeps the lruvec's memcg alive). This moves
>> the stat updates out of the lru_lock critical section and turns the
>> per-folio updates into at most one update per LRU list per batch.
> 
> This updating of stats after dropping the lru lock does introduce one behavior
> change i.e. race between reparenting on offlining and stats update. I think it
> is safe and correct though. Better to document it.
> 
>>
>> The batch is attached to the lruvec while lru_lock is held so that the
>> LRU add/del helpers don't need to pass it down. To keep struct lruvec
>> from growing, cost_lock is moved into the hole after lru_lock, which
>> leaves room for the batch pointer in the same cacheline as lru_lock.
>>
>> The stats can now lag behind the LRU lists by one batch, which is well
>> within the per-cpu batching they already have.
>>
>> On a 2-socket Skylake (80 CPUs, 2 NUMA nodes), with threads pinned to
>> CPUs repeatedly faulting in and freeing memory in a single memcg,
>> average pages per second over 7 freshly created memcgs per run, 2 boots
>> each:
>>
>>                      before    after
>>   shmem, 20 threads  4.74M     5.47M   (+15%)
>>   shmem, 80 threads  7.94M    10.33M   (+30%)
>>   anon,  20 threads  3.04M     3.35M   (+10%)
>>   anon,  80 threads  3.23M     3.41M   (+5%)
>>
>> Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com/ [1]
>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> 

Thanks, I'm planning on queue this.

-- 
Cheers,

David

