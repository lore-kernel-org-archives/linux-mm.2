Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0649606A33B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 09:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eDSNbXk1
Received: by kanga.kvack.org (Postfix)
	id C15BA6B05B2; Fri,  6 Nov 2026 04:12:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA0E46B05B3; Fri,  6 Nov 2026 04:12:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6CE66B05B4; Fri,  6 Nov 2026 04:12:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E0B66B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:12:18 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F781A879E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:12:17 +0000 (UTC)
X-FDA: 85404127914.05.ABEFFBE
Received: from mta1.migadu.com (out-44.mta1.migadu.com [95.215.58.44])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9B1B61C0002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:12:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eDSNbXk1;
	spf=pass (imf18.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.44 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793956336;
	b=1VfaopDZWN0lVWsCVM6KLhDYp0cwT4xF3DekmQi1zmDqXlzHs9XAzOiBrP/vyF1IiDqAno
	q6InRvBemQdBviyE739ZA8MnjXKCjpBitN5sHyu+agpNF21Z+f4xviicvM57OKpX+iJJKo
	8n/Q3PaPa7fjxyJIjB7Gp2Ly2ffgYcI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eDSNbXk1;
	spf=pass (imf18.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.44 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793956336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FU4+q6u/OsLFgFaCnY4cj+PQmLDqknYoJspT5tQVk2o=;
	b=rN63Ong3vaZvGzX5XOg9NPyeEa7Vs+Y75X4pBu2KXHPDAnCL0tyoufUTsLyqEUfTld2Dph
	1gRQKinruuUeZ6KbMrFqELDErbl/f7SRl+xhttR07KqmRwVEfFgPQ2kOM/WYxgPM335XT3
	yUeGzj5j0wTdBncbMilukE/75v3M4/U=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EcP7tMfRcqfAvgoH0gXVXtHAsN+lMrgLB2oyqBdVo8c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793956334; v=1; x=1794561134;
 b=eDSNbXk1104OrMa7I53rBqPpa0V4cS2YoF7NfMFChLxfhTTTvrzuGTP63HfVewdMF8/p9/E4
 c2HM+fP6qCUkJX//cuKuT9mnPaMd3A3dXcD+sJw4O56aLrPw4LtSLUjy5olAPag39iK8+HoQxJG
 WjVl743LfNRVxsS58rnRa2Eg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id d18d573a7e491a03;
	Fri, 06 Nov 2026 09:12:14 +0000
X-Mizu-Trace-ID: d18d573a7e491a03
X-Migadu-Flow: FLOW_OUT
Message-ID: <07a6ef5a-3f28-47b8-a063-912f70977035@linux.dev>
Date: Fri, 6 Nov 2026 17:12:04 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/zswap: fix double decrement of the LRU node count on
 writeback
To: Yosry Ahmed <yosry@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Nhat Pham <nphamcs@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>,
 Dave Chinner <dgc@kernel.org>
References: <20261028113619.38752-1-kaitao.cheng@linux.dev>
 <CAO9r8zP15iW3ECW2Bs0rfyZrifeisDunLa6qJC43M1RcE16wWQ@mail.gmail.com>
 <auJkvb-Lq0M5Enkz@cmpxchg.org>
 <2bd4f0df-80c7-4d32-ab50-1225681ff6be@linux.dev>
 <CAO9r8zPuDtn1S0g8rDnXNfSdZ6uuH1geXALDN5-X_SZpM_W+wg@mail.gmail.com>
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <CAO9r8zPuDtn1S0g8rDnXNfSdZ6uuH1geXALDN5-X_SZpM_W+wg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i78zpzceeymoyjdferrp3xeqiq6wj7mw
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9B1B61C0002
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793956335-4948
X-HE-Meta: U2FsdGVkX1/flh6mt/jhoHrT6HKiffudxJIG29TNExHQQkog2q5XhdJ1/ScPDgjnFa3dRrFEcMsdJY6JlYFT+1lMUTDxrSjTDe1hy5ZeF10jXM8KsSl7dMUqdpP1CmwzgQJVS7k34Es37P/I5nTv5On8aZWaAWCZRbIonDGaSYYnylM7KPf8HAqtEEFK/340ZFUgAkcqrXmWVTccqXSkRqmg1sjAIC+Lms8IIHC3lQfo8QlkAVr+9T3d3PrZ+2kb3BOzzHgq2HzfryNXUaQfqy0AavUwtXMZ4+pM+gLu9PSFrzC0oomhnspIsu+KtRCp66hLz9R8EYSAFlF/B0bmdxtpE+ia1R/m4QFrkmp0K0PBJM4CUCsUtfZnb7ZYtO5xpAN2uh8yMK2ofC08y3NdkTAsgaUdV+KSvnrmwlHLjaeToAB5Ukw5sEWWvhqLmrc7VLoWZdGSVkXt0ZyELv9eS6wHLEIj9tsMaFpFJ+ZVnnOV68jezeN3+n4itr0aA8T5pFtXygLEtgq1TqqYQAuiSoJI0Ugv8htrzCcRaRxuHyMyBqjEICvLUgF6Iuj1mvEPMSfd7s/FUFy6UmHD74pCvsE31CRr7GxPknjKoz6i9OzKVZ9FtVz/Xgx+KIFsV7mIIfn8TXOJsz7EIGd4KtmV2xDCVuZvC81Bm0+Gigu0LO7swwXVjN+GY+h1u+eGaHcmV/5PukuMo8+0ubqfoHgB6Ix1topiYkbeoZZCEqhH5YtBREKDjg65H4XSxXD/yhHy29ETa/1LFVKk+wps+XWWssqTOMXr3ewWrjmLIIONlNFKECFeKxaHkndfuP0Yh+30mcnkiPf/8YZei2NQXw7LpKHce1/LYvFc2yF9kQ0zB9l+C3BrBG3wz1oF8J1dF7wY/inSnC0ALzE1rXjBYWZRP2HBB68gwnhjC8tNHww6UIJwgZOkn8OLzRYMjeU/gl3Nj0wj9JYh0A1lS3dfCuU
 rIe4X4FX
 wtqXTLvjiPrLnuuvpTZIFxAYtiV89OwWoexk1ZvS/kV1XzzBhaluI+Y1lFDXOcj6xhEocNFGCGwdhLUZZwtuXe9gW87yiryxNT0WIt3hHguU6URCe+LzNGKBdWdgtIlhB3uv+48jfVF6YrX208DWXfEv2wpZmxr46Xfzu1OrKOwXmZvfI4bUO9aETcArBQahTF0sfvVp4GBP5qOwVcJZrMQMrSZNqoXdudvZLJjYxfcVusUiTLSB2SxfjLid+0iROKoRBUYyuRDjLLfRTPyIHln75cF+NoNk7exqc05GowUp9Y3qsR6/Y9xrHzApPpAs9HJTRxwEnTI6LBHg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

在 2026/10/29 23:10, Yosry Ahmed 写道:
> On Wed, Oct 28, 2026 at 9:23 PM Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>>
>>
>>
>> 在 2026/10/29 05:10, Johannes Weiner 写道:
>>> On Wed, Oct 28, 2026 at 12:22:43PM -0700, Yosry Ahmed wrote:
>>>> On Wed, Oct 28, 2026 at 4:36 AM Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>>>>>
>>>>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>>>>
>>>>> Successful writeback calls zswap_entry_free(), which removes the entry
>>>>> from the LRU and decrements both the sublist and node item counts.
>>>>> shrink_memcg_cb() then returns LRU_REMOVED_RETRY, causing the LRU walker
>>>>> to decrement the node count again.
>>>>
>>>> I wonder if we have a valid use case for adding LRU_REMOVED_COUNTED or
>>>> LRU_DELETED instead to simply avoid the decrement.
>>>
>>> It bugs me that it's the walker, not the callback, that adjusts the
>>> count. That composes poorly with the normal list manipulation API.
>>>
>>> How about pushing the accounting into the isolation callback, which
>>> can then simply use __list_lru_del()?
>>>
>>> The tradeoff is that more things need to be passed into the isolation
>>> callback, but that seems reasonable. It does make the change noisy,
>>> however, and we might want something like Kaitao's change as a
>>> backportable fix first regardless.
>>
>> I tried three approaches.
>>
>> The first was "pushing the accounting into the isolation callback", as
>> Johannes Weiner suggested. However, as Johannes's example below also shows,
>> this would require extensive changes across multiple subsystems. I doubted
>> that such a broad change would be accepted, so I dropped this approach.
>>
>> The second was to add a new flag to enum lru_status, as Yosry Ahmed suggested,
>> to handle cases like zswap where the callback has already decremented the
>> count. However, the incorrect lru->node[nid].nr_items value in zswap is only
>> an accounting issue: I could not find any code that reads this counter for
>> zswap. Changing a generic interface to fix an accounting error with no
>> apparent functional impact did not seem worthwhile.
>>
>> The third approach is the one implemented in this patch. It keeps the changes
>> within zswap and fixes the accounting issue, so I think it is appropriate.
> 
> I honestly think it's a problem with the list_lru API, as Johannes
> said, walkers compose poorly with the API. So I prefer we either take
> Johannes's suggestion or add LRU_DELETED, unless there's strong
> objection to both ideas.

In v2 (https://lore.kernel.org/all/aupITfr9pBKPrU20@dread/), Dave Chinner
explicitly objected to changing the common interface, so we need to revisit
the fix. Otherwise, progress on resolving this issue will remain blocked.

> FWIW, we don't need a minimal fix for backports, I don't think this
> needs to be backported at all. As Kaitao said, I don't think the wrong
> list_lru count is being used anywhere for zswap.

-- 
Thanks
Kaitao Cheng


