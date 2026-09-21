Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D076C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 06:05:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AA316B00DD; Mon, 21 Sep 2026 02:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4823A6B00DF; Mon, 21 Sep 2026 02:05:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BF786B00E1; Mon, 21 Sep 2026 02:05:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B89F6B00DD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:05:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0CF0A8057F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:05:06 +0000 (UTC)
X-FDA: 85236731412.05.8136571
Received: from mta0.migadu.com (out-156.mta0.migadu.com [91.218.175.156])
	by imf18.hostedemail.com (Postfix) with ESMTP id E50881C0004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:05:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X67TVo1G;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.156 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789970704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TDvZB/C+jirkBkD04ZYSHXv/566UF8Povnh7Bz0JEiY=;
	b=iE2JhdTDGXiP5c1A2ZJQJ66//lcMQtNVvGJpWq1wo1Rwq2KI/L5hxJADUG2kh7R8oP5K0s
	MHbB50IynFlvACGihdpi0std9q+1dcbzSWCN22fW/kfwxRUJ+vCqY0UTdEYDVSm03AbiOR
	dQxoh0s/dRdGav3Oyy1eCVOVmJIU1lw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789970704;
	b=MGc4rYshZeHWHiZ1AePfIvQfNByKsVBIzhX1Rul6r4wyh+6JMfjCTdD8trMuZ4dP1A5S8I
	2TG3gUFjOWzGHgoqZZReKziOt8V9ME+ohDH7n+s6OUkwZzXxIdW2pvM7nX+qiGgMhnOJH6
	kAPZXWItiVOpg8TW2amfxqmfmZ+oWis=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X67TVo1G;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.156 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JKNlOfm2sJQD+Fasu1nejxoblPL/n9RwFvgZgcZ9rjQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789970702; v=1; x=1790575502;
 b=X67TVo1G4oP6xSq4gKrUdNH0CFz1mleqg2cJgU1Q0LT32xcTky75T7teXkYcE/y9YwdfTAq3
 OleIRYMU8vUfNXUF814VAhHbb78l+DbHspz62v9hmgKdKq9nwmN6TgSPOdqEZymH5cI3TtWxhgO
 JL6oZBfN3cjo5R+JxQUMtPWA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a1f83f1d62af5fad;
	Mon, 21 Sep 2026 06:05:01 +0000
X-Mizu-Trace-ID: a1f83f1d62af5fad
X-Migadu-Flow: FLOW_OUT
Message-ID: <2e878fe2-473e-4dc1-a669-7e2e37894d6e@linux.dev>
Date: Mon, 21 Sep 2026 14:04:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2] mm: vmscan: put rotation-missed folios at the
 LRU tail
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260920132519.3369946-1-ridong.chen@linux.dev>
 <CAGsJ_4zCADpQDqVj=BFipOztctBMBhw9Wcj+FLVcj-d8e=0bow@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4zCADpQDqVj=BFipOztctBMBhw9Wcj+FLVcj-d8e=0bow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E50881C0004
X-Stat-Signature: zrmkcxrhkn5ieh6aptt4ncz5xf7rw86q
X-HE-Tag: 1789970703-809509
X-HE-Meta: U2FsdGVkX18eS4hOjuGHBUciVTg41TYy9bjOnJLrIx3DDQohxhprUqUv7e++7HH1MzaXUfPWfbBgnabik/cCglkxAIbV2Ox6WotQBtl4MqE92N6y4kHk6h3QUGj2Q12PiYFirudvb7siHRoYJVPjerfJuSnNWdWiF8m33t+UTaXF9w0+X8kwJ7dPh1WqVuTtxJVf/7yC5cHhLYPhejXn1X69LoYxID4sSH1O5YiKDvxEN/qJIollHQAMw9yGqNNvjWTZrPee8yfJeyQb9AzXSuE/fnBzLdEvIcVJqKI0AiMkYCT6cuglyxSKUB0ahyzd84GHkJltVksNBo3U0EmHG4KRd4XdW7qBEQB6NDH0oW4tCjyqYnheJS6mt70un1Kgs20HXt5EQu7KcHkRaDgO1muMwruqS439/7WwE4Mfev+N/da7A/JnKSCAzERr4IAd6LIN3jRL2BJjwjDM1UeIi++xIRw1I3aSMipTR8TZWVXXyHs7l04P3a9mubKxs4gef5hNZr1ucTe3CWlBfSuObbtJ3tjHZSs3laKO0HqRT53Y5Q1namOpCFc3J8Vj81t9fmH3yx5o0FzixwgR2tekfdBoUSXgWR4zEtYR2pEVX1RF2DFheYZwkjkSuOPOXJ+hL7nr6WTo8pyty6aNDzVkchns2GMm2kW/5GjrrVASUFRsjUpNx4Fk52k3Nji55vJEX6UfA9B7h3+k/6Wt7438eJaMsyYSTGSWfPEJNEmmkxawrBCQif9H2j0EUYO9bJEk+c+duLHabk1RdLhYJHejCsblqZJALrwGzQbx3Nc6HMAdesLYfl7wSpRDPyrByAjclj3z1Zi303pc9/O9PUm8xbj6jBYMM2QYtzUEHMrHpJskvDJ+bbB5mLq6xGxqdXpPXfkNlxEVFtSzUH+eifh938v6RVgbpawXIdyzk9rMI49AImC9EvlNR5yqScgxUnP54u+yeS1YNd1zL+1TQ1B
 +RX3eyj4
 ud5e4L+JOXwMdEhXbjOk+wbbNJUzc8YDOqjPRzrsemqE35FDtgap6k1C2wCP2XnLmVMBxSGgM8TKlY4knmK54azZGIH9GcH1Hbeyac4PuigkyfPqU/7dLW3THMmD3LZJBYm53oclhn62XB+XRUQcLext35NZoka9dpTlHrS7TclchfHVfxwi2IEfX4pGke6njmN1H2hW1QCfCanBCY15ewRS2S3UxR0O956HC36wjsNR4xHDAcbCeGg+jUubSLDMD1A7awKZEkNFun9FvxNefjQSzL+7OnrxBOx2aKPCQojnWfWkGhmIE77AHOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/21/2026 5:31 AM, Barry Song wrote:
> On Sun, Sep 20, 2026 at 9:25 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
> [...]
>>
>>   mm/vmscan.c | 24 ++++++++++++++++++------
>>   1 file changed, 18 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index e200ce3eb056..91295070ca33 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -1971,7 +1971,7 @@ static bool too_many_isolated(struct pglist_data *pgdat, int file,
>>    *
>>    * Note: The caller must not hold any lruvec lock.
>>    */
>> -static unsigned int move_folios_to_lru(struct list_head *list)
>> +static unsigned int move_folios_to_lru(struct list_head *list, bool do_rotate)
>>   {
>>          int nr_pages, nr_moved = 0;
>>          struct lruvec *lruvec = NULL;
>> @@ -2018,7 +2018,19 @@ static unsigned int move_folios_to_lru(struct list_head *list)
>>                          continue;
>>                  }
>>
>> -               lruvec_add_folio(lruvec, folio);
>> +               /*
>> +                * Put clean, unreferenced and unpinned folios that may have
>> +                * missed folio_rotate_reclaimable() at the tail to avoid
>> +                * cold/hot inversion.
>> +                */
>> +               if (do_rotate && !folio_test_active(folio) && !folio_mapped(folio) &&
>> +                   !folio_test_dirty(folio) && !folio_test_writeback(folio) &&
>> +                   !folio_test_referenced(folio) &&
>> +                   folio_ref_count(folio) == folio_expected_ref_count(folio))
> 
> 
> I guess this is wrong. We hold an extra reference while isolating
> the folio, so I think this should be:
> 
> `folio_ref_count(folio) == folio_expected_ref_count(folio) + 1`
> 
> Am I missing something here?
> 
Hi Barry,

Thank you for your review.

The folios we want to check have the following lifecycle:

1. In isolate_lru_folios, we take an extra reference (i.e., +1).

2. In __remove_mapping, the folio can only be frozen successfully when refcount 
== 1 + folio_nr_pages(folio). We need to exclude folios whose refcount is not 1 
+ folio_nr_pages(folio) (e.g., those pinned by GUP), as reported by Sashiko.

```
	...
	refcount = 1 + folio_nr_pages(folio);
	if (!folio_ref_freeze(folio, refcount))
		goto cannot_free;
	...
``` 	

3. In move_folios_to_lru, we drop the extra reference and move the folio back to 
the lruvec.

```
...
		if (unlikely(folio_put_testzero(folio))) {
			__folio_clear_lru_flags(folio);
...
		}

		if (do_rotate && !folio_test_active(folio) && !folio_mapped(folio) &&
		    !folio_test_dirty(folio) && !folio_test_writeback(folio) &&
		    !folio_test_referenced(folio) &&
		    folio_ref_count(folio) == folio_expected_ref_count(folio))
			lruvec_add_folio_tail(lruvec, folio);
		else
			lruvec_add_folio(lruvec, folio);
```

The refcount check is added after the extra reference has been dropped.

Therefore, I believe it should be 'folio_ref_count(folio) == 
folio_expected_ref_count(folio)', not 'folio_ref_count(folio) == 
folio_expected_ref_count(folio) + 1'.

-- 
Best regards
Ridong


