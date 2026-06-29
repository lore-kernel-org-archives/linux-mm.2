Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5415DC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:14:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18F216B0101; Mon, 29 Jun 2026 09:14:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 140556B0102; Mon, 29 Jun 2026 09:14:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 031286B0103; Mon, 29 Jun 2026 09:14:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9BE26B0101
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:14:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4DE571C35F7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:14:47 +0000 (UTC)
X-FDA: 84932995014.07.992BAF9
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
	by imf12.hostedemail.com (Postfix) with ESMTP id F09A540013
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:14:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738885;
	b=mTDOivIKQtXJXoKTHZk3w+qI0JCGqlomDpPUMRPkNmcqWOVkZe8yHVwg5epNXNVpQJG/V4
	KVTDi9UMatK0LIp7vog1fNfqqKjM7WBU+28suMNaD3TZ9KpHAojVrWEx1mapPjSg8IOriN
	wqrgSI9U3STE7feB8S2L4ZTfEEwQYYM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2H14PTCGgRnPovgTyCWvRxmHmo4JSVwkJqfrzXGWki0=;
	b=4Py7PS+gnJ20m+nCwkCbNzDgL24b3NaqV1/f5V8ssU7fBk6XJp/OnyhWXVDyZoqHTd27SP
	uIbfH0I81Yzkmt+MCrIY4mh2NyFqk+UrpPHeRXFofWYp/A7tYXRYysTtC8Ulqz8hJLT7bn
	1Z7ibraM+19sC4k1N3jDcocg8Lqbdm4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id 732753ECCF;
	Mon, 29 Jun 2026 13:14:33 +0000 (UTC)
Message-ID: <9a8ba4d7-07ea-4ec5-b158-39fff4796f84@ghiti.fr>
Date: Mon, 29 Jun 2026 15:14:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 9/9] mm: zswap: per-node kmem accounting for
 zswap/zsmalloc
To: Usama Arif <usama.arif@linux.dev>
Cc: alexandre@ghiti.fr, Andrew Morton <akpm@linux-foundation.org>,
 Barry Song <baohua@kernel.org>, Ben Segall <bsegall@google.com>,
 cgroups@vger.kernel.org, Chengming Zhou <chengming.zhou@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Hildenbrand <david@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Ingo Molnar <mingo@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Juri Lelli <juri.lelli@redhat.com>,
 Kairui Song <kasong@tencent.com>, Kent Overstreet
 <kent.overstreet@linux.dev>, K Prateek Nayak <kprateek.nayak@amd.com>,
 "Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>,
 Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Minchan Kim <minchan@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Valentin Schneider <vschneid@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>,
 Yosry Ahmed <yosry@kernel.org>, Yuanchu Xie <yuanchu@google.com>
References: <20260626143244.3382853-1-usama.arif@linux.dev>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20260626143244.3382853-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: dmFkZTEhcHMOV035Brtm/30GMjuKs4O8ybg1XVe8gULLwhvSfXgYn07oxXBha1LOO4SZc0DeEFoS5fudMz+QqvNxWMuclG2EXzgnUz6MG7jBufK2db2Pz9S1hTnddmsNtu5odXAl6oVeXxR0rcmAK9ObOWrBAvZKXBtlSRm6CgtBMv7zkkMWiq4Vl5LYcLRwvqr1hwlPXRHgJJan28sAxeLjBHyHXg5Y9oYM5ugZ6syKYnTpW0m5FDejjro5Bl1B/Iwxsd5K1QTgDOXoES7PR+HogJRw9qbSTO5yzpGl9ivh2imPg2lOJkg8lad0v+A6kMv9HLz9heypCNcF+m1F7CIaTNheBvSX5Phu11J0UYB3e+SsRVPSS+RgoVFp+YIOkUE3xtNV+18SAQfjZbAehErT37gVHxCVGXCJWAogFw+aA5RmcmDHa3B1gPoj/jf9UstzQXYLZi9TzbUE3qOcl76zy1i92277AuB7XDy3wNMymBlozSgOPZWPa7GrQQUySNBup8YcCaMlaTy/yJQZGRFXvL6ta7RDywM6fLR7zKoopQZET+W+lLwSrfjp0iChrCh7ktzBUXcaQ1QvtXU2dpvR26M6Q25eG0FDDh8GHdpE7d2UAbK3biF0HG9p8h9YIzjPXJsZ9SUUQti6L86m32FllNJ6njvWI4SXJCU6CM/pMkcOmQ
X-GND-State: clean
X-Stat-Signature: iwysezzurd6t34yzoa8zynrsnw65qyzf
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F09A540013
X-HE-Tag: 1782738884-967476
X-HE-Meta: U2FsdGVkX19J6TPE9Vtly5yf79tNI2EGQ0BkNaw77wRVZhY5KJFhPQhaQVeTtxhZaSQBfieTJV2eyhQW6uHp8S30acCuFQI5k5OpEzCekhaCFhUgnvvvQd0ORKJN8V6M57tBdx3Mgx2mtQDyTldrQZt0XJpd8s674ywKmvojD4DMjwA6JqzYs1mFJZlAKk5nzTr1IQpZpLp5cpmBw9VWE4l5mtAaVfhoIUuZWRb5VKiMKRGoYwTEKSrAm+iZ6MJW7YoKZ3D+7W+7bYXtiXhFxm3M+f+Ocb64CJArgVAivwmyZK7mVHtJs1yakyAfp1P8lijTL86NhSIrTMVdpo2Y7zbtw4awqyEgV/S7F6vrRp8jSm94AJX1KhYaZ5ROZIKmfdxraO5FfW9MhGiXhrm21yRiE/uBluJlZ4lvByo88iTl4XhkVSjGpMuOz2Utclao+vfe6p8T5mkvHCow4cxMtIcSrJ3KvwJ7fF3NdJj987C1tDQmztlMKmUcQWVeUEUk4YsVlIZuWPGFj7tEt/BODbqAjxfECeQ3m6C4cYPTpjlWRVYQOorrRiKo8slE+LHCUQFRLP+zexpoAU7Zp7zuhLR1G63zmzKZ16u3uh8ZTuFfiKVf8Z6LnWP5Sb6QnlChC/22dercofpS+tkuhFfV19xgBlqOVtlxrkZViG2RtH2+70xDYZ4b+30U51qoVM23YBHHOHcmjJ9CQvF2VVaZGXbEcQY//mqf/R30CIQ5AINEOcth9WO9LVUYDf1JqtJkFXXcA099DsCcj7+EmpIQH4XrDwSive37sKdP7bLdS+tIAcSG5gLslywDh/7sEUGnLW4+BX/xXbYaGt7YffKhwFXooxcL70VYZdkR1Rv/Pi6GJdWIs+zPXJdTxaZtgKfXS2Hw0Yk0E9lpMZ8lm8En1aYezw1UoBrV+ytoZYifTYp1pnngHUVOShLsZYzcpAe5M1T+YgOklEKY0Zrjhu/
 EDUS2icr
 O6a+MZK0l/7cuI+YcJmRhfQrbUDjWCgnan+c0FJdUx7tL/MYIaYyGYq4Ne7RgzIkmPHcfxL2DyHdwqwMetAGPjPEf34Gb+1Cd6afW8T9NrfoFeH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Usama,

On 6/26/26 16:32, Usama Arif wrote:
> On Fri, 26 Jun 2026 12:20:58 +0200 Alexandre Ghiti <alex@ghiti.fr> wrote:
>
>> Update zswap and zsmalloc to use per-node obj_cgroup for kmem
>> accounting, attributing compressed page charges to the correct
>> NUMA node.
>>
>> But actually, this is incomplete because it does not correctly account
>> for entries that straddle pages, those pages being possibly on 2 different
>> nodes.
>>
>> This will be correctly handled by Joshua in a different series [1].
>>
>> Link: https://lore.kernel.org/linux-mm/20260311195153.4013476-1-joshua.hahnjy@gmail.com/ [1]
>> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>> ---
>>   include/linux/zsmalloc.h |  2 ++
>>   mm/zsmalloc.c            | 11 +++++++++++
>>   mm/zswap.c               | 19 ++++++++++++++++++-
>>   3 files changed, 31 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
>> index 478410c880b1..30427f3fe232 100644
>> --- a/include/linux/zsmalloc.h
>> +++ b/include/linux/zsmalloc.h
>> @@ -50,6 +50,8 @@ void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle);
>>   void zs_obj_write(struct zs_pool *pool, unsigned long handle,
>>   		  void *handle_mem, size_t mem_len);
>>   
>> +int zs_handle_to_nid(struct zs_pool *pool, unsigned long handle);
>> +
>>   extern const struct movable_operations zsmalloc_mops;
>>   
>>   #endif
>> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
>> index 83f5820c45f9..17f7403ebe77 100644
>> --- a/mm/zsmalloc.c
>> +++ b/mm/zsmalloc.c
>> @@ -1380,6 +1380,17 @@ static void obj_free(int class_size, unsigned long obj)
>>   	mod_zspage_inuse(zspage, -1);
>>   }
>>   
>> +int zs_handle_to_nid(struct zs_pool *pool, unsigned long handle)
>> +{
>> +	unsigned long obj;
>> +	struct zpdesc *zpdesc;
>> +
>> +	obj = handle_to_obj(handle);
>> +	obj_to_zpdesc(obj, &zpdesc);
>> +	return page_to_nid(zpdesc_page(zpdesc));
>> +}
>> +EXPORT_SYMBOL(zs_handle_to_nid);
> Does this need the same locking as the other handle-to-zspage paths?
> zs_free() takes pool->lock before handle_to_obj() because zspage migration can
> update or move the object behind the handle. This helper does the same decode
> without the lock, so zswap's uncharge path can race migration and charge or
> uncharge the wrong node, or observe transient zspage state.


You're totally right, I missed this, thanks!

Thanks,

Alex


>
>
>> +
>>   void zs_free(struct zs_pool *pool, unsigned long handle)
>>   {
>>   	struct zspage *zspage;
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index 761cd699e0a3..466c6a3f4ef3 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -1438,7 +1438,24 @@ static bool zswap_store_page(struct page *page,
>>   	 */
>>   	zswap_pool_get(pool);
>>   	if (objcg) {
>> -		obj_cgroup_get(objcg);
>> +		struct obj_cgroup *nid_objcg;
>> +		int nid = zs_handle_to_nid(pool->zs_pool, entry->handle);
>> +
>> +		/*
>> +		 * obj_cgroup_nid() returns a borrowed RCU pointer (no
>> +		 * reference), so the returned per-node objcg may be freed
>> +		 * (kfree_rcu) before we use it. Pin it with a tryget inside a
>> +		 * single rcu section; if it is already dying, fall back to the
>> +		 * folio objcg (held by the caller) so the charge still lands on
>> +		 * the right memcg, just without per-node attribution.
>> +		 */
>> +		rcu_read_lock();
>> +		nid_objcg = obj_cgroup_nid(objcg, nid);
>> +		if (nid_objcg && obj_cgroup_tryget(nid_objcg))
>> +			objcg = nid_objcg;
>> +		else
>> +			obj_cgroup_get(objcg);
>> +		rcu_read_unlock();
>>   		obj_cgroup_charge_zswap(objcg, entry->length);
>>   	}
>>   	atomic_long_inc(&zswap_stored_pages);
>> -- 
>> 2.54.0
>>
>>

