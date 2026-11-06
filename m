Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E93A2606A31B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 01:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pI8kjQHR
Received: by kanga.kvack.org (Postfix)
	id BC8636B05B1; Thu,  5 Nov 2026 20:44:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B79366B05B2; Thu,  5 Nov 2026 20:44:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6B726B05B3; Thu,  5 Nov 2026 20:44:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 725756B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:44:19 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB8DC1A0CEB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:44:18 +0000 (UTC)
X-FDA: 85402998996.09.9C0EB81
Received: from mta0.migadu.com (out-80.mta0.migadu.com [91.218.175.80])
	by imf09.hostedemail.com (Postfix) with ESMTP id E6435140009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:44:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pI8kjQHR;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.80 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793929457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dew6EzCqiWafyHsHJpopQwo/cXSuzlwoO/rf90tBbGc=;
	b=bSiVaDAvJLgWn6Hz2QDu4Og17c9P5s9XuL6tpzbyt9XdZUuqXCA/7rh8Vdm091XYD/bjvJ
	qgOZqaw3vpY1SX8Afc3/8RXRG/eYgaKcyHw8ckd4T97Qa7UWKD5EToOHV3hSNCUYBSRbVi
	rM4ka+4hJ2l38zIN/cspvop8fDT3tEU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793929457;
	b=YcjPhdaOqVYdogUngiZh5rd7sg3wtOr5jKlGXXOZ8UUuedbAUurCxcYN9NOdJeTvtGFCe4
	FWM5wbDZrGk2Z5Iw+OCQpWEPy9K6u5zZlNv0j2Y8wifcColk4Hq9EFtYWPyIAJxaEHmrI7
	t+KCKMrCTlVTa8OiSk12bybHFLdwdcU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pI8kjQHR;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.80 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LvBe8nocYbjsZeluU6geuvGEmKucxs6vvjV6JlKiFg4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793929450; v=1; x=1794534250;
 b=pI8kjQHRH8kUKUAnHaChegvFFy8HWqNBBWoeVhOnRpsHU0wBDy0gJUnUl63Szx8XNtjW7GMP
 O2uHw3mU3h+NC70ImK1nuSxFGlYa0ryOKEnOOCAjjHJziJ3MpITVSqA/19fQuWUHHGP0OMr3W9c
 dE31C6tl043ZfrQEO+Kt1uFc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e4cd8311743e1b88;
	Fri, 06 Nov 2026 01:44:09 +0000
X-Mizu-Trace-ID: e4cd8311743e1b88
X-Migadu-Flow: FLOW_OUT
Message-ID: <57d2a4ca-8edc-4291-a919-8a74abda94a5@linux.dev>
Date: Fri, 6 Nov 2026 09:43:59 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/3] mm/mglru: skip the flags cmpxchg when nothing
 changes
To: Kairui Song <ryncsn@gmail.com>
Cc: David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Joanne Koong <joannelkoong@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20261105132220.2233677-1-ridong.chen@linux.dev>
 <20261105132220.2233677-3-ridong.chen@linux.dev>
 <CAMgjq7DtU+tSOgQWgTaV0obLwkkUwQqgvtTXjG2qf8L+iPXbiQ@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAMgjq7DtU+tSOgQWgTaV0obLwkkUwQqgvtTXjG2qf8L+iPXbiQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qqdccgfhir6qy9mkg17qdbd7d9pms3b6
X-Rspamd-Queue-Id: E6435140009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793929453-743112
X-HE-Meta: U2FsdGVkX187S1vcaISE7y0WdjpPRnBg5sSvgue+rqwDDuRkUwX65EkUzdeef6qGDKZmq1DHFfTOuG5zpxHfu+rKXTuncMaUlR/dl9KYyZkmnuHHqwABlNrMTqnHYEo19ak9v+CxOKpZqucSzCbSZuh55dXV9BNrNe9/rVbUdOl9Z4n86JJOaEPZH93A82O9bvx4kzj/mUomffU0CYdplYX3N2KtzzA3zYth6oljTf4ivhfGxUf5Eg8yhD4AffbPnCoOe8BWzZf6jjLdTX74MmCwNy8+tROKWV/CCSap0olLYW0+1aa4uIMRlckNZ7S6yOLvHtvClH39odv7J/dWU/ihjWmJdFm1BUvKowAApCXuSO/yhXzV+5MppScZPXWbsoWX95yr5BFgHBXZ/7JnOWq0eWhL1Yt5FuCweh2HedlNZyRDRWqXqcTJw00vWk8RSmgxqfMpzCUtVz5MK29/qnB3KY/tigNkNi+0AjijBgjF7LkXgOv8Y1RleC3v1XxlDuMREt0S5cXbrvfcjXrU0jM7SgVO3L2azKaPktRWCbKWo5uCvkFffMFCwqqFPiQbIvqxRz9Ik5X2FKsOiJ5ECTGDMQDSd5Cm5oPYAJtM5H2bebwD9pZl+PbS1d44gN4FwMW5QKl+JepmED2O+K7Z2r0D7+9+tyLp8HarISsIiU89NnwRgyOi3RkuWtQ4lw/7+F7hsekc4OH8Kxy0Ava72xFLwWkMl57gYQD9iNIKnbgQ1IQ6jPwPVPuCRzJgfX6zxTxR7jmvlfhaJO+sQiRJzUqhS57Z04vPC6yLz4/7LIqipoTeBY15oT6jVnQacKfysNd5BuBCbXJbxpjoSM0LEui3RlDWb28Pa42BoMP0Lv7NC/mWme4jvxm7tXXm90HvhVVKQxBVL4n/TznRNTDOZwPzqGxpB6Oo8XCEAg7oaXwFP3oisBLHL04FnffhZgI/aEl8pj5xma7YcMmZug+
 NcZB4s7P
 ZmCxBdfUiXYBAetk7qIYJfPjUlB/tSCKvsNG2VxSpMWbIPnVwdy2sI93W3VHl69tPq8qDtWmwNHLNzjP6XuRIFrjvRqCWgsVEsXzmkCkQ0xqJkfbKIz69+s9gMgHcPPfUGFInTEXpMghTr7I4t40uJxAd+XokT07mOcZk44lVdmXmrwhtG0MTqwYW1RFX9qLSOoatlR7bFwW8U32P3CqUMqNlS4qqrfkhnebZeXWX8/do9SIuS6HUXl/sSS0PaOWh813+oJh6E80cjdJnvn06rFAmWI58kHPuGibCH5qLbIfiwa/xP1HqBoKxOpOjuJQkeddPmENdpEW1itlPz49NHkJzTzjNtVsvYGVRr4m1/Li4CAJzRWfsHKdmUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/6/2026 12:21 AM, Kairui Song wrote:
> On Thu, Nov 5, 2026 at 10:11 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> folio_update_gen() and folio_set_lru_refs() always end with a
>> try_cmpxchg() on folio->flags, even when the new value equals the old
>> one. The locked instruction still takes the struct page cacheline in
>> exclusive state.
>>
>> That is common in practice: a folio mapped by many processes is visited
>> once per mm during a page table walk, and after the first visit it is
>> already in the youngest generation with refs cleared and PG_workingset
>> set. isolate_folio() and the eviction paths also call
>> folio_set_lru_refs(folio, 0) on folios whose refs are already zero.
>>
>> Break out of the loop when the flags would not change. The result is
>> the same as a successful no-op cmpxchg. The only difference is that the
>> full barrier implied by the locked instruction is gone on that path.
>> No caller relies on it: the eviction and isolation callers run under
>> the LRU lock, and the others (page table walks, folio_mark_accessed(),
>> lru_gen_clear_refs()) only care about the resulting flags value, which
>> is already in place. Note that lru_gen_inc_refs() already returns
>> without any atomic when refs is at LRU_REFS_MAX and the folio is in
>> the workingset.
>>
>> Tested on an i7-13700HX with turbo disabled and the performance
>> governor. N processes map the same 2GiB tmpfs file (huge=never) and
>> read every page, then one aging pass is triggered on their memcg
>> through /sys/kernel/debug/lru_gen ("+ <memcg_id> 0 <max_seq> 200 1").
>> Time per aging pass in ms, median of 5 runs of 10 passes each, averaged
>> over 2 boots of each kernel:
>>
>>    processes    base   patched
>>            1    32.9      31.7   -3.5%
>>            8   195.1     160.2  -17.9%
>>           32   755.8     592.2  -21.7%
>>           64  1597.2    1260.6  -21.1%
>>
>> With one process, every visit changes the generation, so there is
>> nothing to skip. Before the patch, perf annotate attributes 53-58% of
>> the walk_update_folio() samples to the lock cmpxchg in the inlined
>> folio_update_gen() in this test.
>>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   include/linux/mm_inline.h | 2 ++
>>   mm/vmscan.c               | 2 ++
>>   2 files changed, 4 insertions(+)
>>
>> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
>> index b3d85fe91385..4ba9079f4dc8 100644
>> --- a/include/linux/mm_inline.h
>> +++ b/include/linux/mm_inline.h
>> @@ -244,6 +244,8 @@ static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
>>          do {
>>                  new_flags = old_flags;
>>                  lru_set_refs_flags(&new_flags, refs);
>> +               if (new_flags == old_flags)
>> +                       break;
>>          } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>>   }
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 50c352e9ffef..3fa76715382d 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -3398,6 +3398,8 @@ static int folio_update_gen(struct folio *folio, int new_gen, int *type,
>>                  lru_set_gen_flags(&new_flags, new_gen);
>>                  lru_set_refs_flags(&new_flags, 0);
>>                  new_flags |= BIT(PG_workingset);
>> +               if (new_flags == old_flags)
>> +                       break;
>>          } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
> 
> Hi Ridong,
> 
> I had the same idea in V4 of MGLRU-FG which is posted a few weeks ago,
> with the same code:
> https://lore.kernel.org/linux-mm/20261016-mglru-fg-v4-4-2106750c0bfa@tencent.com/
> 
> + if (new_flags == old_flags)
> + break;
> 

Hi Kairui,

Oh. Sorry about that. I read the series a few weeks ago, but as it is large
I missed this change. I should have checked it again before sending.

> I didn't have time to benchmark that one function but the e2e test
> showed very trivial improvement, it's a good improvement though. Feel
> free to add:
> 
> Reviewed-by: Kairui Song <kasong@tencent.com>
> 

Thanks for the Reviewed-by. If you don't mind, I'd suggest merging it as
a separate patch, as the test shows the benefit of this small change,
which makes the code easier to trace. I will also mention in the commit
message that it is a small part of your series. Does that sound OK to
you?

> BTW there are a lot of concurrent activity is happening for MGLRU at
> the moment so conflicts occur very frequently...

-- 
Best regards
Ridong


