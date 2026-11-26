Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78638606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 02:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=glK1n/aT
Received: by kanga.kvack.org (Postfix)
	id 1FE966B05FC; Wed, 25 Nov 2026 21:16:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5FB6B05FE; Wed, 25 Nov 2026 21:16:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 113846B060B; Wed, 25 Nov 2026 21:16:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E37136B05FC
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:16:24 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 711511A0274
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:16:24 +0000 (UTC)
X-FDA: 85475655888.27.92BBACA
Received: from mta1.migadu.com (out-75.mta1.migadu.com [95.215.58.75])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4989E180005
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:16:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="glK1n/aT";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.75 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795659382;
	b=tMGFzCFOcNV1Ml9exqoqIM8h07vaZ46o7VBqGPfiMD3fhPeMFNLv0P+68W9k55zXR94HRx
	kHIBQ22HCCrsR05kx5AJEcAoaqpLRCzJ9Y4qL8H7HNPanbCaH9KcjL281yXocU9yfFGtxz
	Xc3/4tpSX5ymUKuKL/n7YnUsr+ScbLk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795659382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eX55NWichw8jUoF661UMxH6wBwQaXsLXwWsZF2v6FY0=;
	b=2bcJ6AmBppI04uHhTX3KEFlYHU0knYiIeSL5qVwbeuOp4mAjLM36SZUkSkiSnBc9nnr1rN
	32dmA4xXY4WmosBIGoKiKqm+u7W3pXsOlE8TWrSXBAa+IUMWjac7kTDaLlek2y05lIKmvP
	AsC/OXHrpkVT9HfoCaNoRRZtT0ZBvn8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="glK1n/aT";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.75 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6cDXZrBmxUBxQ3BydmU2oUpNhZDqygc9wolThAVI+lk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795659380; v=1; x=1796264180;
 b=glK1n/aTnSCez0oanYn+Is661RJ0AlJuVyLZNtwAfTt+k6JSIcS6yW48nLwB1haL910kBhbE
 F/LtUhj0/xHR+GHvhe1SAPo4iVdbZYJDay29+D550RymGxkHAtjTd8ldCEbKNtQpjM91SNr9Mj6
 Uevr9UlSkXHgSfceTUbPPGyA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7d6f2a109074e204;
	Thu, 26 Nov 2026 02:16:20 +0000
X-Mizu-Trace-ID: 7d6f2a109074e204
X-Migadu-Flow: FLOW_OUT
Message-ID: <d61f15b0-6546-4a11-a749-3c27d743df00@linux.dev>
Date: Thu, 26 Nov 2026 10:16:10 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm/mglru: pass a seq range to lru_gen_add_folio()
To: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>,
 Johannes Weiner <hannes@cmpxchg.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Yu Zhao <yuzhao@google.com>,
 linux-mm@kvack.org, Ridong Chen <chenridong@xiaomi.com>
References: <20261125094056.3973331-1-ridong.chen@linux.dev>
 <20261125094056.3973331-2-ridong.chen@linux.dev>
 <CAGsJ_4x1k+-HtNU7zCPcsKwYyYfiW95+Jxrd-SvCWZm8Sq6B0A@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4x1k+-HtNU7zCPcsKwYyYfiW95+Jxrd-SvCWZm8Sq6B0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4989E180005
X-Stat-Signature: n4idonfjn7ynwhmew5x6dc8gtusgwfu9
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795659382-860867
X-HE-Meta: U2FsdGVkX19CjRg0Fv976MkpQ09JQH9ad3+XzoL/SEW45cKSgLk8S8HQGkmoG8QIQZNYMllc512fHepvlv2f5O8+eZm6lrz7xfwwkaGPbXlJybRB3VhvB9B5QUPkli8gI1LUaKJeUnw8Y/RUJ3pKbPhGi2we50Ezdf8H7daLYrCZHQSDeKoBj2Hw7AA8g6mLeVv83mWuTeAbHg+j6YjOV/tvdgDBIsnanfyEw6uONv47TwTYvHpVlcBYhfxSd9hOH0lOgmXzph/t+PkUtWmdqeeQe9r6xp45ZbZ72Qxa7HDCjZNAyPA+8rB9LqBpXgVSl1IBIjNZvLuPvedjEzdNf1YvLJ4N/xHEnMYcENLP4UaV2W6UVoZIizxL4oMhS1MNjfJp30N0qwe3AF7h9Fs31yRCzackuJUFDkuId1pt/jh2GhXuXsVrZf9fj5yjfE8cIlq6dN1Fl711loAwDC5d4ozhm9roQZ2NJdD6zlOQItYmpQ36Y23Kga4GasQba1LBapC1DHXhpL0eaXEglY+cFtoGwH1m8M1VNNN91BZUZU62ET0+pVUqF7MPlYfIosPcD4qvgcyzpeP2rjVojLf1U6Apip5kvGGnLa5TMqdoPuSg9HSuRIXBAtqTGZ/wsXUNsF3DzUPVvvl7YN5NlxaoZdQ3dB1tsjB1lyZW1NQDkpjE1QPVWkGLSwjnoImJq92Hmi4y5xyg7ZnbDRfJCFdihEqrVycR/Td4Iyq3ku2wVOGr6XX0NydKVOJjmkY3fpmnxXkyxhp4rL6ilxEI7XgxSN+ZCN6QSMy850y3YOORDafDzwDuqQ3RqUs7Jfj2gtwzozinOyFxK55PxYp7LrAxauQ9HE3rAhT3kJtjUAfZJWSflEwdF3QAagWH97pnufTBdcBaEX/C17OsGRdVrCj5PKljXht52Sas6vWQdsC2Jmzt1EoVUgcoqj1lexmWNRbtEp/IzOUce9ncuL+8LTo
 QMjuKWGy
 hVQGYmN7Tinq9dxO9l6ahl8lT45KUycszSRkopmUGQAxL+pKA5Fve9GX4bAHzwuuWOD1VQdo6eQQsBOmXlpJooa3wygnVxZxCdOP7BCZhllcQvF3gaGWevvw9kTNJ6nwITV30WeLHKRBYUUQINPBYmSfhvzSCw0ejW2wscLTXj5dTVo2v0AEh7NwFgjWlNIu39xF+3mI4rsRX1/b0ps/0x1R4rLqeLsCmD+rdbvgcgX7ynPRZBsLZUJCHuL7sFEqV5pWxoNg+i5emGpo0qPfT/VGx2SPzBz0FMQrIHG5uXulhlU34bswlnZRxekTJQvpTt4m9cUey54xP+/lpLDZQbgk4EHqhJ/YtWYnvdaBYl3E5UZs9/czNSAt/p2eoBoPrCA4sUGh5UDJ2wzjBNx/M8M1S42FhVLviRyUYvTkP+20igpl9au4jq4PsdKcP2gksqeCQKmheFbDoqOn+i+J8pQUQxhcYlUbW4ElZaQhdfwrfWjjOBotTQSILFczuzGpoTN8ZB3NHkoN+P1m3lRVs/GjEwnd2SgBZM+7k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/26/2026 7:57 AM, Barry Song wrote:
>> +/*
>> + * Cap the seq to [min_seq, max_seq], see MIN_SEQ_UNBOUNDED and
>> + * MAX_SEQ_UNBOUNDED for no limit. With no limit and tail set, the folio is
>> + * added to the tail of the oldest gen.
>> + */
> 
> Another option is to make tail and gen orthogonal, so that tail
> isn't necessarily tied to the oldest gen. This would be similar
> to the deactivate path, except that we would only need to set
> tail here without changing gen.
> 
> Would that approach work as well?
> 

Yes, that works for me, and it is cleaner. tail will only pick the
list end, and the two callers that pass tail=true will pass
min_seq[type] as max_seq to keep the folio in the oldest gen, like
the deactivate path in patch 2. lru_gen_folio_seq() never returns a
seq below min_seq[type], so this gives the same result as before.

The changes on top of v3 would be something like:

lru_gen_add_folio() drops the if/else:

	  seq = lru_gen_folio_seq(lruvec, folio);
	  seq = max(seq, min(min_seq, lrugen->max_seq));
	  seq = min(seq, max_seq);

lruvec_add_folio_tail() is outside CONFIG_LRU_GEN, so it reads
lrugen under the #ifdef:

```
#ifdef CONFIG_LRU_GEN
	  int type = folio_is_file_lru(folio);
	  unsigned long seq = READ_ONCE(lruvec->lrugen.min_seq[type]);

	  if (lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED, seq,true))
		return;
#endif
```

fill_evictable() caps only the inactive folios:

```
	  max_seq = active ? MAX_SEQ_UNBOUNDED :
			     READ_ONCE(lruvec->lrugen.min_seq[type]);
	  success = lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED,
					max_seq, !active);
```
Patch 2 stays the same.

Does this look good to you? If so, I will send v4 with it.

>> +static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
>> +                                    unsigned long min_seq, unsigned long max_seq,
>> +                                    bool tail)
>>   {
>>          unsigned long seq;
>>          unsigned long flags;
>> @@ -406,9 +413,12 @@ static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *foli
>>          if (folio_test_unevictable(folio) || !lrugen->enabled)
>>                  return false;
>>
>> -       seq = lru_gen_folio_seq(lruvec, folio, reclaiming);
>> -       if (scanned_seq != -1UL)
>> -               seq = max(seq, min(scanned_seq + 1, lrugen->max_seq));
>> +       if (tail)
>> +               seq = READ_ONCE(lrugen->min_seq[type]);
>> +       else
>> +               seq = lru_gen_folio_seq(lruvec, folio);
> 
> Then we wouldn't need any if/else branches here.
> 
>> +       seq = max(seq, min(min_seq, lrugen->max_seq));
> 
> Thanks,
> Barry

-- 
Best regards
Ridong


