Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9887D606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 06:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=qdguq5E8
Received: by kanga.kvack.org (Postfix)
	id AB6B76B0283; Thu, 22 Oct 2026 02:41:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A663B6B02A8; Thu, 22 Oct 2026 02:41:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955ED6B02A9; Thu, 22 Oct 2026 02:41:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B50C6B0283
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:41:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 302851C3E0F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:41:32 +0000 (UTC)
X-FDA: 85349316024.20.EA60B13
Received: from mta0.migadu.com (out-122.mta0.migadu.com [91.218.175.122])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2CBB11C0006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:41:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qdguq5E8;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.122 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792651290;
	b=BwB5FrribLwPUjS+d3jcjAhOMBPqp7ri1Pzdj0Bql3aof8sUWwHe3IrPbIp0mEpSecCnpg
	3iXFB9dyZbow30VY38QRMfSHDaOktAlmP8RwHZeCj5wPivicMKqXk8vCXcVzrYGI+0PeXt
	TlNIyXCZuR3LGlOes6ElXBCfdLfEMFI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qdguq5E8;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.122 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792651290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oomb1UC4+J7/JXIq7MZuRh69ueKVTwJKjBpxLuJuCOU=;
	b=sYEemAo/LNBxdcHCZH0pjD3kPZQlmHy5ArDoX81K5J43rjZ82CD949gd6/9bKHlnGEEW3A
	0BYtJolxVYZUtlMxqjN4vGD6GGzckWcujdztIjxXOMW6bBPW/bjfRd2nl7e0xFKEQNzNYY
	Kod89GnU/soE2mWc1xkqA9toH3HaE5o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=z0k70oB6eYWMzSZVpd6lStsINTKiyAgBeVketd5m+rM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792651288; v=1; x=1793256088;
 b=qdguq5E8NQqyfAYGJ3rmQDBG02pfEhEeNptF4R6J7JqCC8ipibwWeQAlDeJyFc5Q5P2oagmc
 UPFJeNNyDlwnBirAaUsHnLVX4X709D3np1GkMXNp8VO7wZb9YV03s2U2ftyI7yDBIjMRPV+ycNQ
 iP1YVelePly5Ra9JH9W6Q9f0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 38152b391e1a13e3;
	Thu, 22 Oct 2026 06:41:28 +0000
X-Mizu-Trace-ID: 38152b391e1a13e3
X-Migadu-Flow: FLOW_OUT
Message-ID: <813b3f19-1cfc-4d07-a9b8-ea20f8fb0bee@linux.dev>
Date: Thu, 22 Oct 2026 14:41:13 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new] mm/mglru: clarify the generation placement in
 lru_gen_folio_seq()
To: wangzicheng@honor.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20261020023548.3242028-1-ridong.chen@linux.dev>
 <179257189711.741142.157439930403322311.b4-reply@b4>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <179257189711.741142.157439930403322311.b4-reply@b4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2CBB11C0006
X-Stat-Signature: 8zwzd3babj8rz4yzre3rm66hssw9eo9b
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792651289-532086
X-HE-Meta: U2FsdGVkX19eSowH6Qhk7XQOuI8Jh1QnP31zaIK3dT1Cj+XtUlsniNJtX5A3C44pUtLDz7I9GSHQw0qn4ZvSKzvXqCtEd5D38aXmMew10gbyGSKR1FyveHoImeYFLAnBjRklwgxCEJzy9GFhiIsbLvG89OlWCeDu1sZmKt+pUgU8tMvFkpra7CRUHhDDX1kR9cWr3E8IAoYjHdlV+JNCLH/6rmlHiIE+SMK0EpHn/nIbXxhC6yKGV861ICD2Lumf8z4DRnYFhw4qGq1/HZBOCF1rRFOl0+hjCE4o5z4e7Eetk5f61zv95HdHWR6mpvIx+bEIJ0Km7ZzWmWR/5K+ytvIV0O8OR1tw/tCLBbjUrY7zlDpQz1zMQQIBiz2T98AxWgtPoUrgupuR6oUswmqODAi8gt5rVVSzp/iB04iiUhJtHM9JBsE7vX/WEFpp76xhlMnc7SPTzfHe12QaJXAhc194Zul7yES1tLqahmjZl5pkHJ361pNux9iOKYUpix3dMpUQGEsmh4HX5kRROhajO6V2E2+oCqLSWSq8GrTfhoOIEap+B+5A7Az+vsH5/b5N5qMjpEXE1KbmmNMg2/J9oHgA3l+e/3Xk5vKgF5TH+qtPu32HMLMQXDLN7qhJ2Ok5XhS6vt6sOuzODMVSg7VVcttRpxK2GmjLUNDbHPdDO/6Je8Uomver3KcJhf1kbKznI1ZlSyxg7+pIZ8RuSdP8H1d/vLF7fIuSNkp7b2INnQk8YWpELjuCZaIGNw4DT9tq+qzrsl+o/0edbZFMWJBFoByEjwIBYcRjWNcpyUJf8J5REplMrG+0IzKAC+oupojpBCpnEcpog8fzE3XPmlGW7zvbW53fPZTLOfz3Ku/biFip+JLN9xAcw5xbObPXra2H8ACjaikEwWtd/HrOy3+XIi3WrIP1ElX/kXbOgfCp8dQhppxW+95dd22VtV88teN3WURu2U2xzaAvNVsoijp
 u1knGWjT
 UFEK8s5TKmovwzrDhdVwXTc4UK+9fVcLQDLl0ygwz9BenPsmLPIZO4muf/FWDGBuXsOf19D1Uq8htv+LjBeTQCESQ5x0IquszJFvfNn6ifU13jLZ8IwffoDBYFNJVYXJWUOQ41/WcBV9Z6jajzuH3pnTd/uXjvjLaHqYBSGyJqdpcWSBzs6rI1hQep7E0/bcvnqJ50iphzJzSlk8M/WPnQN8cZxqCHUlCrEbm5me6m0bGjnUvR0jo9xthPIbfC4uV8evc8dYPc0+Cf1r0qqCXxCXllARj0+mjz3v60O3DBIPd93fxC56K17xWBJIuSog0rGIGXlwlsTiHNF3oaZs8igZDASxeBFRU3RC2x/UNTqAZJbLj4PDfludft4nG81VHAGpuuw7phYatHZunFZxdae2FGvmHLXtn048ULTrO6YhdzC3ZIXHskjD+qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/21/2026 4:38 PM, wangzicheng@honor.com wrote:
> On 2026-10-20 10:35 +0800, Ridong Chen wrote:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> lru_gen_folio_seq() computes how many generations below max_seq a
>> folio should be added to, but stores it in a variable named "gen".
>> Elsewhere in MGLRU "gen" means an index into lrugen->folios[], i.e.
>> seq % MAX_NR_GENS, so reusing the name for a relative offset is
>> confusing.
>>
>> The comment table above the code also no longer matches it. It only
>> covers the PG_active and the final branch, leaving out the reclaiming
>> and "can't evict yet" cases, and it lists LRU_REFS_FLAGS as an input
>> although lru_gen_folio_seq() never looks at it.
>>
>> Rename the local variable to "age", redraw the table so that each
>> branch maps to the age and seq it produces, and note that the result
>> is clamped to min_seq[type].
>>
>> No functional change.
>>
>> Assisted-by: LLM
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   include/linux/mm_inline.h | 48 ++++++++++++++++++++++++++-------------
>>   1 file changed, 32 insertions(+), 16 deletions(-)
>>
>> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
>> index ab69b9930893..a933d8c14558 100644
>> --- a/include/linux/mm_inline.h
>> +++ b/include/linux/mm_inline.h
>> @@ -302,34 +302,50 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
>>   					      const struct folio *folio,
>>   					      bool reclaiming)
>>   {
>> -	int gen;
>> +	int age;
>>   	int type = folio_is_file_lru(folio);
>>   	const struct lru_gen_folio *lrugen = &lruvec->lrugen;
>>   
>>   	/*
>> -	 * +-----------------------------------+-----------------------------------+
>> -	 * | Accessed through page tables and  | Accessed through file descriptors |
>> -	 * | promoted by folio_update_gen()    | and protected by folio_inc_gen()  |
>> -	 * +-----------------------------------+-----------------------------------+
>> -	 * | PG_active (set while isolated)    |                                   |
>> -	 * +-----------------+-----------------+-----------------+-----------------+
>> -	 * |  PG_workingset  |  PG_referenced  |  PG_workingset  |  LRU_REFS_FLAGS |
>> -	 * +-----------------------------------+-----------------------------------+
>> -	 * |<---------- MIN_NR_GENS ---------->|                                   |
>> -	 * |<---------------------------- MAX_NR_GENS ---------------------------->|
>> +	 *            +-----------------+-----------------+-----------------+-----------------+
>> +	 * age        |        1        |        2        |        3        |        4        |
> Hi Ridong,
>    
> Agreed, I also found this part confusing.
> 
> One problem with the new name: in MGLRU a larger seq/gen means a
> younger generation, but a larger age means an older one, so every
> read needs a flip (max_seq - age + 1). Assigning the seq directly in
> each branch might read more naturally.
> 

Hi Zicheng,

Thank you for your reply. We both agree that this part of the code is confusing. 
'age' is not perfect, but it is much better. The bigger the age, the elder it 
is, just like human age. And it is a local variable, not used elsewhere, so it 
is fine for me.

> Also, both tables run past 80 columns (~95 for the art in mglru-fg
> 4/17, ~96 for the redrawn one here, tab as 8). Would you consider
> something vertical and shorter? I had prepared a comment for
> mglru-fg, and since this is being discussed here too, here it is
> (conditions are per mglru-fg, where the flags became the refs
> count):
> 
>      /*
>          * The seq is clamped to min_seq[type]:
>          *
>          *   destination     | folio state
>          *   ----------------+--------------------------------------------
>          *   youngest        | PG_active, refs >= LRU_REFS_WORKINGSET
>          *   (max_seq)       |
>          *
>          *   2nd youngest    | PG_active, refs < LRU_REFS_WORKINGSET
>          *   (max_seq - 1)   | anon folio not yet in swapcache
>          *                   | PG_reclaim folio, dirty or under writeback
>          *
>          *   2nd oldest      | refs >= LRU_REFS_WORKINGSET
>          *   (max_seq - 2)   |
>          *
>          *   oldest          | reclaiming
>          *   (min_seq[type]) | otherwise: refs < LRU_REFS_WORKINGSET
>          */
> 
> With a comment like this, developers can see the generation
> placement directly, instead of working it out from the code.
> 

Thanks for the table,

As Kairui replied, he did not want more code details in the comment, which may 
change a lot. And Kairui will pick this patch with his FG series. Although I 
wanted to add the table, Kairui felt there shouldn't be too much detail.

What is more, I think the following is needed—it is what this function initially 
implemented.

+-----------------------------------+-----------------------------------+
| Accessed through page tables and  | Accessed through file descriptors |
| promoted by folio_update_gen()    | and protected by folio_inc_gen()  |
+-----------------+-----------------+-----------------+-----------------+

> Best,
> Zicheng
> 
> 
>> +	 *            +-----------------+-----------------+-----------------+-----------------+
>> +	 * seq        |     max_seq     |    max_seq-1    |    max_seq-2    |    max_seq-3    |
>> +	 *            +-----------------------------------+-----------------------------------+
>> +	 *            |<---------- MIN_NR_GENS ---------->|                                   |
>> +	 *            |<---------------------------- MAX_NR_GENS ---------------------------->|
>> +	 *            +-----------------------------------+-----------------------------------+
>> +	 *            | Accessed through page tables and  | Accessed through file descriptors |
>> +	 *            | promoted by folio_update_gen()    | and protected by folio_inc_gen()  |
>> +	 *            +-----------------+-----------------+-----------------+-----------------+
>> +	 * PG_active  |  PG_workingset  | !PG_workingset  |                 |                 |
>> +	 *            +-----------------+-----------------+-----------------+-----------------+
>> +	 * reclaiming |                 |                 |                 |     always      |
>> +	 *            +-----------------+-----------------+-----------------+-----------------+
>> +	 * can't      |                 |  anon && not in |                 |                 |
>> +	 * evict yet  |                 |  swapcache, or  |                 |                 |
>> +	 *            |                 |  PG_reclaim &&  |                 |                 |
>> +	 *            |                 | dirty/writeback |                 |                 |
>> +	 *            +-----------------+-----------------+-----------------+-----------------+
>> +	 * else       |                 |                 |  PG_workingset  | !PG_workingset  |
>> +	 *            |                 |                 |       or        |       &&        |
>> +	 *            |                 |                 |  PG_referenced  | !PG_referenced  |
>> +	 *            +-----------------+-----------------+-----------------+-----------------+
>> +	 *
>> +	 * The resulting seq is clamped to min_seq[type].
>>   	 */
>>   	if (folio_test_active(folio))
>> -		gen = MIN_NR_GENS - folio_test_workingset(folio);
>> +		age = MIN_NR_GENS - folio_test_workingset(folio);
>>   	else if (reclaiming)
>> -		gen = MAX_NR_GENS;
>> +		age = MAX_NR_GENS;
>>   	else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(folio)) ||
>>   		 (folio_test_reclaim(folio) &&
>>   		  (folio_test_dirty(folio) || folio_test_writeback(folio))))
>> -		gen = MIN_NR_GENS;
>> +		age = MIN_NR_GENS;
>>   	else
>> -		gen = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
>> +		age = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
>>   
>> -	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_seq[type]));
>> +	return max(READ_ONCE(lrugen->max_seq) - age + 1, READ_ONCE(lrugen->min_seq[type]));
>>   }
>>   
>>   static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
>> -- 
>> 2.34.1
>>
>>
> 

-- 
Best regards
Ridong


