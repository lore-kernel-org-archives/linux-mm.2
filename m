Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D52F0C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 12:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCAB46B0092; Wed,  9 Sep 2026 08:43:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7BB46B0093; Wed,  9 Sep 2026 08:43:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C946A6B0095; Wed,  9 Sep 2026 08:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 994136B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:43:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C15711401DA
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:43:40 +0000 (UTC)
X-FDA: 85194190200.25.63BFBD6
Received: from mta1.migadu.com (out-60.mta1.migadu.com [95.215.58.60])
	by imf09.hostedemail.com (Postfix) with ESMTP id 16942140008
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:43:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rJAONsKd;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.60 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788957819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/7UknrQ67b7g3uRRQUzYs8NMpxkz/uJA2wLrvf88538=;
	b=JQkW1QBdPcIw0LvnHKYQONUqpyFowQiDUcBYxz7pxrY2dgUj3KsFODI+LTdg/8v1t3E46Z
	5IX/EXcoQpASKaUXwFr8UC0Kga6AUgUyZlC3a1yt8N0L4tSx2kA9B/sgONo+WZxqJ1pWvM
	qyxvb8Y/po4OCaw1tcCm39JJjrpBSTU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rJAONsKd;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.60 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788957819;
	b=s9VqmmXXmTb3CU7A60z98ui3Dn2fOkydnscp2bliFxjG5zACqH+kh7WtWQbZliQmmYTaKX
	lhK8D8qhgoWv1HWSy1PU+o/0byJ6oiz6wOeWfq7bkVqAUAPh75nPwgprIibBVweRJ2o0LS
	zmgfjtR6FnZ91psy8IFJI4hmnTnkhiU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jqiubL+tagB99Gjb+Dzn8xdJMbDXci+TetbI3A6BRTs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788957814; v=1; x=1789562614;
 b=rJAONsKdu+sg+H/uk6gTd2G/TsAB/Jc0+tG+jAvP/PyL4wDIrKwqC9W5BhDm4PVsESHGmtAs
 yDh+KXYaTxl+Btmbn5r7SvHvuxrMi5B8DF7n91yeQcRcBDvfzXJsqrWksFQtfDZJL3GETqFjEJ4
 cIdr3XgOPyxygcWJ5tvCqfZQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d2d73bfd903f7147;
	Wed, 09 Sep 2026 12:43:34 +0000
X-Mizu-Trace-ID: d2d73bfd903f7147
X-Migadu-Flow: FLOW_OUT
Message-ID: <ebd30222-01db-491f-852c-bf5261f95f47@linux.dev>
Date: Wed, 9 Sep 2026 20:43:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 2/2] mm/mglru: add tracepoint for inc_max_seq
To: Barry Song <baohua@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260907042447.2450663-1-ridong.chen@linux.dev>
 <20260907042447.2450663-3-ridong.chen@linux.dev>
 <CAGsJ_4zvJmdiicZAefUyjn4RjP=hBxE95fjpR9HM+SFJ8S_aCQ@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4zvJmdiicZAefUyjn4RjP=hBxE95fjpR9HM+SFJ8S_aCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 16942140008
X-Stat-Signature: 5cczy5abqdn35gpkijf8qxmao4e5njur
X-Rspam-User: 
X-HE-Tag: 1788957816-293289
X-HE-Meta: U2FsdGVkX198m386EZCyzop/hrJs8GeAOGb5hE37wGXC2n6/vdriyetfpL99h5XiPgQnv1BippQI5DBVSRedMnUv1hr6lIhkI/ozAQchejUl2eOpMfFHUoiA26qID7MALSo/q30ZS5URavGU/NInihmDv/yYM9epPSIzY24dm1LvOAFXUXOgJDB945zggAplGhDMGRaOxWXvq99RSrqQwiELSWGqvUoC9WgAgC39MCDmharO3rF9KZeV/AEbYGmX2sPxbNE8ap9qFmuAo672WV6tV/bbp6qVyExIQbzOYUYKPyyDIJxchNE1wetTNZIBDJu1ouOMBZvcn2byRLHGyfNShYpIbiAtPCY0t2TwO9+UcgMeRVSPC0Ethzc/QHgFBL8y9Q+f+kXylS5FZmLifDAyiJdxzlrbSpy+Y6PXJ2OUcDBWLlJG5m8yPTsxHGDjvHcpTDMkXF/VaE04eW3heUfYrpnUzjdFxFlO0yhblBSY4Ai6H3QdO5kjSJxHSRgKscCGTlGMcmK0k87H2XJthIH7AiIWipwLCisrx+v3H1/6MgopDxH84EzXwZnvx1zLQIJusNK/Tgh7hdjcsTB6bnennj3yySl0RR2RIaJqWzFaDEv00AGtx7vuiBKpCo5CsntC0L9kRKCgiGDCI0pEsGVbPWBJB0KWUHqF21bTzu35l5SJq/J52DFEWIv5Q79+m5rHIseXDlm1cC4ISsNygVJGeb2irNa7iOHASqh2V1zpCnElVAo1YfCafl7ydMB1v9Ch/302opfIh9IvzRExUf+SFrMhHJz5wrh448qYY5nd5UQbXU73pxa37R2YsGpSIufzgjQ0ay4WscwFFRNuqVMIrxBq3kemdDqgAV/mhtS93A3eCJdGCrdUUDYO8sF64uTtAP0oCkT7ePQamgVXNJNUHpDqpd4c3rIXshIMlzSpO+5YWpdanWpSiZWLt5AF14NDFDHMQn2XllIgPpB
 8hy9S6VD
 O1UJib9N8EUfviIjnQP0O3brLViOR5Q32q8DEmZLr5rNf8pY3mBuR6yWiqr+AvWyXzRG5Ur+zYHmeWTc/5buojCK64ijKJuJawlU/pcd3qLR449OcbM8Ky3pCa9LmXe0xYdb0Zid/0kr6XTgCmg6yQsSv+RfptEsUYmB+iAL9GsFkvb8bnugZqOfH7HGFZZcNEGFUKr6rKQnvV6XZH8zQ2f0Bx8dXv2ERcTgcJYtnwdkcgqg9cjEhO+2SGVZV9YTnE+CmIg7fNeq7zIx6h41Y6jnp6g9GgwVzTwItSOv4FBtRtspzJrGOSZIICTSTyBwN2gsngtIUU+P3ZUwLUUL3VG9fUkZmoMcdiJtK4n1MSy5OaHshZ3eoIN0KIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/9/2026 2:45 PM, Barry Song wrote:
> On Mon, Sep 7, 2026 at 12:25 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Aging in MGLRU advances max_seq via inc_max_seq(), creating a new
>> youngest generation. There is currently no tracepoint on this path, so
>> the moment a new generation is created, and how the min_seq of each type
>> trails behind it, cannot be observed as it happens.
>>
>> Add mm_mglru_inc_max_seq, emitted right after max_seq is bumped, with
>> the memcg id and the new max_seq alongside the anon and file min_seq.
>> Paired with the mm_mglru_isolate_folios tracepoint it makes the full
>> aging-to-eviction window observable per memcg.
>>
>> Assisted-by: Claude:claude-opus-4-8
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   include/trace/events/vmscan.h | 30 ++++++++++++++++++++++++++++++
>>   mm/vmscan.c                   |  4 ++++
>>   2 files changed, 34 insertions(+)
>>
>> diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
>> index a0e3cf75294b..ab93c2f4b318 100644
>> --- a/include/trace/events/vmscan.h
>> +++ b/include/trace/events/vmscan.h
>> @@ -439,6 +439,36 @@ TRACE_EVENT(mm_mglru_isolate_folios,
>>                  __entry->max_seq)
>>   );
>>
>> +TRACE_EVENT(mm_mglru_inc_max_seq,
>> +
>> +       TP_PROTO(u64 memcg_id,
>> +               unsigned long max_seq,
>> +               unsigned long anon_min_seq,
>> +               unsigned long file_min_seq),
>> +
>> +       TP_ARGS(memcg_id, max_seq, anon_min_seq, file_min_seq),
>> +
>> +       TP_STRUCT__entry(
>> +               __field(u64, memcg_id)
>> +               __field(unsigned long, max_seq)
>> +               __field(unsigned long, anon_min_seq)
>> +               __field(unsigned long, file_min_seq)
>> +       ),
>> +
>> +       TP_fast_assign(
>> +               __entry->memcg_id = memcg_id;
>> +               __entry->max_seq = max_seq;
>> +               __entry->anon_min_seq = anon_min_seq;
>> +               __entry->file_min_seq = file_min_seq;
>> +       ),
>> +
>> +       TP_printk("memcg_id=%llu max_seq=%lu anon_min_seq=%lu file_min_seq=%lu",
>> +               __entry->memcg_id,
>> +               __entry->max_seq,
>> +               __entry->anon_min_seq,
>> +               __entry->file_min_seq)
>> +);
>> +
>>   TRACE_EVENT(mm_vmscan_write_folio,
>>
>>          TP_PROTO(struct folio *folio),
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 771fe6827939..3c806a57d113 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -4065,6 +4065,10 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
>>          WRITE_ONCE(lrugen->timestamps[next], jiffies);
>>          /* make sure preceding modifications appear */
>>          smp_store_release(&lrugen->max_seq, lrugen->max_seq + 1);
>> +       trace_mm_mglru_inc_max_seq(mem_cgroup_id(lruvec_memcg(lruvec)),
>> +                                  lrugen->max_seq,
>> +                                  lrugen->min_seq[LRU_GEN_ANON],
>> +                                  lrugen->min_seq[LRU_GEN_FILE]);
> 
> I suspect we also want to know the number of pages in each generation,
> similar to:
> 
> /sys/kernel/debug # cat lru_gen
> memcg 1 /
>   node     0
>            0      25672          0          85
>            1      25672          0        4249
>            2      25672         21           0
>            3      25672          0           0
> memcg 19 /A
>   node     0
>            0      23036          0           0
>            1      23036          0           0
>            2      23036          0           0
>            3      23036          0           0
> 
Thanks.

Will add.

-- 
Best regards
Ridong


