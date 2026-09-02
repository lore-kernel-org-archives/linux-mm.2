Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B530CC624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:44:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA91D6B00EF; Wed,  2 Sep 2026 07:44:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80936B00F0; Wed,  2 Sep 2026 07:44:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD1D6B00F1; Wed,  2 Sep 2026 07:44:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9C8AC6B00EF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:44:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33B55C01BC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:44:39 +0000 (UTC)
X-FDA: 85168639878.07.976EE6F
Received: from mta0.migadu.com (out-250.mta0.migadu.com [91.218.175.250])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0A42920009
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:44:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IULNUPg0;
	spf=pass (imf03.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.250 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788349477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4iunfluJkJk5C2LpFg5DYMpHqCk2d7lhZCAuOzFN74s=;
	b=wE5pkErsRLB2I7is990V9u86yt9Ua1pTFDQAm3clXZoIng5rNcJ/dqoVCHiVQycwRaKXlb
	RUcQLdLQ1291T+Z+sI/fLDxYKAHIBAdB+dlarJy+xFVY293M04b597UcVRlGpSMkHcZuig
	F8/UpvPA5iWOqmyqGcxjHtAapsOmPrg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IULNUPg0;
	spf=pass (imf03.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.250 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788349477;
	b=l6hq4Lg6CI23jLWV1pcs6PsawVTVTuYF7KHQzlsQ7+UU++yyjFRUsTeK3ekGkODBV6JcR/
	rMJ4b1HoBuITA1j+ldrSsdeSAgqB4oBthmMR48MkwvnA8iZcCtMoyYofTNKzjbJU9Ua74u
	Ii0IKDwzO76cXUMbDJOHBDA/y7Il6gw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FQ3fwj4HF3bn+KhRvieo4GqR7LJ+Nrb7IZb14BFcNNo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788349475; v=1; x=1788954275;
 b=IULNUPg0nHXswditelk/BOCU+pa3bBLxp5InD7yhF3hLPkFdYMUF89ZLtaeOa4AQ1ITHmLRI
 2+Ly92fai4lHHg84v1RdKrxXiGxVUtCuY3toqYfXa/rjScbnzE5/34Lj0sQFEJwH83P57+v1IqO
 qNR21SzIiED2K3s+MwztcUS4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7b46bf04467625a6;
	Wed, 02 Sep 2026 11:44:35 +0000
X-Mizu-Trace-ID: 7b46bf04467625a6
X-Migadu-Flow: FLOW_OUT
Message-ID: <2def1a1a-cb47-4435-bc8a-e787672022ae@linux.dev>
Date: Wed, 2 Sep 2026 19:44:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shrinker: fix bogus set_shrinker_bit() with
 cgroup.memory=nokmem
To: Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-kernel@vger.kernel.org
References: <20260902073800.305481-1-jiayuan.chen@linux.dev>
 <5753d853-df04-4918-9852-c23842c66428@linux.dev>
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <5753d853-df04-4918-9852-c23842c66428@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mepyzjpb57ika7pqdns8xoc18bq9aidc
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0A42920009
X-Rspam-User: 
X-HE-Tag: 1788349476-243773
X-HE-Meta: U2FsdGVkX19WLUhSa/zGFhWSdPb0cmWNJ7HZAsY/itDiLH5mlrYB7DmKGERNtnBibt7K0lKY89k1cOOMQR5SxfKRpFt9kRcUYO6/jwRc9pL6sN4qV/MrvDjvWnj1u3atAaImZQERhX8JBSCYF5Gw6ZAmRdFbfJnTRoQ5NvGSnuOb6imf/Lyn/vLt6JJfXrPai6d0rcji5kLhbm8OqswKeYA+0S/c4CxbqfBbSUVdZdUqFNKSt+LnxRGJvHeUnwHQKO5dB5heWd52klTQxxIBt/5wMa5tjjC/xO06x+42B9Vgwi8acinlHerbQepjewLEymP/8Mk7s7Xaqt5yPM3manmdVFurk59hrB1TASo4f4VjmkWqE3lU+/RiKcmm6JCjxpgJYn1xmRBWW01PT46NmdmjiepjOIrfTWy8j3r42/7K4I0ZkjJsG1MtyrwtdHhEyuVSd+sINw2JS34jdEOhPFFrUkpzjRfWvQuYTf4WrFaY7ytzYUuC5VHl6zdgntOB76e2WhN92AZbxJm/lB23HOoTKCox5TQzLMiD/N6XpFLDyYNXFZV6b5tGcYXdgfOjC1gubymIJWMqmgYn+9o5kM0ZKkiETBpBzies3zloVa6t1BtSiqXCg4JYM1BxWUCNlDrLVgrBiHMSLLQkI5Pqu3a2dVRuKtOeflTykfy0x9x/y5QTI1hBikoCk4Q5+EOyRtAvmiRwqh+TXCmb7pHJlSIa2Ql/4WDXhPvy7ds35I43RIlNU90L+SCf5Kpr9pEzx5e3aj9iTQWrrHjKkTkrWjNC/Ahf63xw+uxICbIVnSWARt8o/pZwP9G8Dc4zBAl08r+DtpVUrvULzPIcQgKRAU75OS9vihAM8GFdEril9NM/WQZKbDeBkYaAGO+msqkF8RJUMXLHI3X1WQaQanbUm8Z9V6mM81x5KMj+PHgf0yM++Oy/k3gaoLfx+JjV34OqyP6/JMqsjCtt5VtBwfS
 J2Gf8JPV
 1vHlezA5ap2YVt/HhvBVuQzYQ8b8Sa0neDwnkqRBV11FmVPU4ZJNyAta0lGpq86xN8xwMt855TG5tEWYtLTWgP/+YcR6WDtdyQWankoHTf+GHs8LmMqDLZ9gpyUrz1XGnh2YzeJ7vs6xDpSo1WT67umIoFQBKAij1hEqLrYYu26i7U5M+II9MehiLwcR52wfclQ2+55L6JqeBrfDiwnpAwWPhSVLgfTBw8IzpBHElWKgf9/IT031W5XXJEzhsCK6kGBgILkCU2mYTkubn+PnvaDHJle5XqO24nWIh5pkFo9UMCt6c9OwLzcMpnw0o1U3ZbHi9G71PYpI9CWpOJu6IJTVKZN0Jz7vtgwnd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


on 9/2/26 7:34 PM, Usama Arif wrote:
>
> On 02/09/2026 08:37, Jiayuan Chen wrote:
>> With cgroup.memory=nokmem, shrinker_memcg_alloc() bails out early and
>> never allocates an id, so shrinker->id keeps the 0 it got from the
>> kzalloc() in shrinker_alloc(). __list_lru_init() then copies that 0
>> into lru->shrinker_id, where it looks like a valid bit index.
>>
>> Nothing calls expand_shrinker_info() on nokmem either, so
>> shrinker_nr_max stays 0 and every memcg ends up with an empty map
>> (map_nr_max == 0).
>>
>> deferred_split_folio() hands a real memcg to __list_lru_add()
>> regardless of whether the lru is memcg aware, so the first THP queued
>> in a cgroup does set_shrinker_bit(memcg, nid, 0) and trips the bounds
>> check:
>>
>> WARNING: mm/shrinker.c:212 at set_shrinker_bit+0x7d/0x90, CPU#126
>> Call Trace:
>>   <TASK>
>>   deferred_split_folio+0x18c/0x220
>>   map_anon_folio_pmd_nopf+0xdd/0x130
>>   map_anon_folio_pmd_pf+0x14/0xb0
>>   do_huge_pmd_anonymous_page+0x1a1/0x620
>>   __handle_mm_fault+0xea9/0x10d0
>>   handle_mm_fault+0xe5/0x320
>>   do_user_addr_fault+0x1cc/0x870
>>   exc_page_fault+0x81/0x1b0
>>   asm_exc_page_fault+0x27/0x30
>>   </TASK>
>>
>> Harmless, the WARN_ON_ONCE() is what keeps the out of bounds unit[]
>> read from happening, but the id should not look valid in the first
>> place. Clear it before returning.
>>
>> Two other spots could paper over this: drop the id in
>> __list_lru_init() when nokmem turns memcg_aware off, or make
>> deferred_split_folio() pass NULL like list_lru_add_obj() does. Both
>> leave shrinker->id lying around for the next caller, so fix it where
>> the id is handed out.
>>
>> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
>> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
>> ---
>>   mm/shrinker.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/mm/shrinker.c b/mm/shrinker.c
>> index a70aab124a0e..7ec2a9704f6f 100644
>> --- a/mm/shrinker.c
>> +++ b/mm/shrinker.c
>> @@ -227,6 +227,8 @@ static int shrinker_memcg_alloc(struct shrinker *shrinker)
>>   {
>>   	int id;
>>   
>> +	shrinker->id = -1;
>> +
>>   	if (mem_cgroup_disabled())
>>   		return -ENOSYS;
>>   	if (mem_cgroup_kmem_disabled() && !(shrinker->flags & SHRINKER_NONSLAB))
>
> Thanks for the fix!
>
> I think the initialization would look better in shrinker_alloc()?


Well, we have to add macro if we move it to shrinker_alloc()


     shrinker->flags = flags | SHRINKER_ALLOCATED;
     shrinker->seeks = DEFAULT_SEEKS;

+#ifdef CONFIG_MEMCG
+        shrinker->id = -1;
+#endif


No strong preference for me :)


