Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1C43C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 12:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 933E36B008C; Wed,  9 Sep 2026 08:00:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4DB6B0092; Wed,  9 Sep 2026 08:00:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FA846B0093; Wed,  9 Sep 2026 08:00:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A4A86B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 08:00:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A18B5C01DC
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:00:37 +0000 (UTC)
X-FDA: 85194081714.23.33A61DD
Received: from mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id 986334000C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:00:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tJxIezej;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788955235;
	b=40I+ZqxAcPtE/lu7+mgETC984cOpTSjZ11GsbwBvtW8Sx3IejE2RElfaXV6fweRsTVERyH
	lojWs8dFxL/vqDkvuOcjgG/igY1iFKHMQtUBsdbpRuJlx7yP6I8Yo88lSqzUrur3acPG4g
	rQ7kxY4fM3VUGoR4if9BrHQJwlSF1tQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tJxIezej;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788955235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=09spd/RvJ2R2Jg+UtcW9j/yS/Dzb5BqcpmAriHc5wNA=;
	b=DyIrZu6tFsJjP1yTAcJACkseW7ZxYaALvqJ59mpq7FKYbfPqwxeswC75zTwgUzg90MyfPU
	tzkqu6YK3WCcEm1Qdm9hMfMI1YR4BxKQhmjkAixn4GX826thaZxQrSqYrKyu3WOdtorUgD
	UaDYa25lhxrQYAQcazVWZwftVBcxiMA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=SwCnXXsaf+fnrTsFYwqQVitrQ3IBYAM246XJcfjgCMM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788955228; v=1; x=1789560028;
 b=tJxIezejdWMqrldv6KuK3+fv2knycsSL08OcGIXbQcrWpeKJxiOcmvIDo61qepZxkHiQHwMf
 1B7v0f3MJt7UViXmPHBNLm+sSxSr7ZLQnZPgW1PJ3ZaZSfUBRm67ruzvU0rexSzLZPpUlK3Wig3
 Q5wNHqLCbafhrS4OPTRHEwhg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1d4edfe393dee372;
	Wed, 09 Sep 2026 12:00:26 +0000
X-Mizu-Trace-ID: 1d4edfe393dee372
X-Migadu-Flow: FLOW_OUT
Message-ID: <102f6ff6-46f9-4734-a056-694eb2c0129b@linux.dev>
Date: Wed, 9 Sep 2026 20:00:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/2] mm/mglru: add tracepoint for folio isolation
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
 <20260907042447.2450663-2-ridong.chen@linux.dev>
 <CAGsJ_4zT0HcbkQjdPFPBeaqbGcYp4WE6sghDzz=0evhhupCs3g@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4zT0HcbkQjdPFPBeaqbGcYp4WE6sghDzz=0evhhupCs3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 986334000C
X-Stat-Signature: 5bahfzs7sqjj83xnydsbaqwdrraot1tr
X-HE-Tag: 1788955233-543197
X-HE-Meta: U2FsdGVkX19UgZhnpGrlLpd9xQd5PzYkWfUYTpft5uo7VgSx4lgkvR7HvWLwl9paI0bUuADFO4+Ag6Sv+1sLbH9QyT+ebGX+sFFnZJMWZdz5lY9uPi0Au35NWStZVpNUgwSMWRHAcoe+WdBRuguiNNuBgpVAzv7DkFTP5elBuwUXZ6qUgVRf9D//0wfaWz+mePsmkpO6VzL8U/u3ks0UUYuWn/HCNfYSkIZHym3qZI4Jr2ANn2XE5eguoRLJ36Pqm7CTVTqNdw2jp3duvoFI41COtiwCtoVK8lVxMz5u5t1rPWuljTuz0bR/zIy3SqEpFlqTEWfbSx/H3Jd5xYAVxjdAGt/YUdUTFWAPkLe5ve9RXwUoPBLVqK/ikIvo+jigYwz68orr/YPuKhmf6phk9YIx4CGB7gvh6WtX5J5WfvsG0GLtCnZQ9uScJdb0Ke5VCn0cuG+WnI/MKa+QnNvJtv0Z6rw9HoqC5QpbMGp2zil9O/1PAtjVAJvs8KOtUMzVQ5CrdqfSF+WaAphVgiI5YZLT8xzPE3Sk7JXZ0ywcxFbkOjck6pfqHgKX3g9/fRxXRkm2b0LEe7o/BPJ/uNajnZa3RYJU/0Z48Yvv5WWaB4++EQJ3UfjuNsmqxHEChFdqyazPg5ZQUcU+JPc3zXHbTDAzBnwYHtePGAt0p6HcBwLuw+P3GBMN8zTSktx2rNALzBBv3vui6hwyddgmsmeSzQIWWuPI1u/IZkDj07xL/7KOSNi1CTGcWmoxPc00r1s1CItUDoGl66Fmg0M/IBX4D+anvUuT+VfkYi0VMoVrV57G2qfeFMz4CyDjt75pM19MG8bEAnfc02JPzUVlmI77nDeaAMU+w36aeuIvzKxmWzOuSyUPCejOcqKRYvmAdLOGFRtD4pWFqLlIyJANOa2Kq5VJThgM2VJPEyrTERyhYjPdd2fhHgONIF6pD4Eeh8gCvZRrrYTGs1cejdyuGEA
 NcvJovBp
 rM9kagU1kAl4/8joHQiq/5q5VuLTq60erIsaAxyG3O/C+5wGi0oToDX4CzgF2aX6Vfr0SYCEnbL3izoABO+3ULcM2RCk8+akE3TC0mVGSvPi1j+tGdFsSMHleTL8QDPlV2sxzWBvlwX88OrAVM2kUnZGOc9D+LEWScv7NX8jyUB6Db8JXw/OvPYq7dwyN+SbxEjoJl5U5b1EL3XtpY8ve4n7zERVMvg1KMs5W9TunzvQ3LR2osCgamjXULwvC4zHQ8Urrf1Ern8+1WiqbkekpxEB7xjbbdWYIVhor1QFbGzSc384KcyVe3CXKKOlepLBazBqy1nllxO6+hs4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/9/2026 2:40 PM, Barry Song wrote:
> On Mon, Sep 7, 2026 at 12:25 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> MGLRU's scan_folios() and evict_folios() emit the classic-LRU
>> tracepoints trace_mm_vmscan_lru_isolate() and
>> trace_mm_vmscan_lru_shrink_inactive(). Those predate MGLRU and are
>> indistinguishable from the classic-LRU path: they carry no generation,
>> sequence, memcg or swappiness context, so a trace of an MGLRU run cannot
>> tell which memcg a given scan/evict belongs to, nor how far reclaim has
>> progressed through the generations.
>>
>> Add mm_mglru_isolate_folios, emitted once per isolate_folios() call with
>> the memcg id, the type actually scanned, the effective swappiness, the
>> scanned/isolated counts, and the anon/file min_seq and max_seq. The
>> min_seq/max_seq triplet ties each isolation to the generation layout it
>> ran against, which the classic-LRU tracepoints cannot express.
>>
>> This is emitted at the isolate_folios() layer, which is MGLRU-specific
>> and has no classic-LRU counterpart, so it neither changes nor duplicates
>> the existing scan/evict tracepoints.
>>
> 
> I have no objection to MGLRU having some tracepoints. However, one
> major concern is that the code is changing rapidly, so the tracepoints
> may not be stable. We would need to maintain them as the code evolves.
> 

Indeed. GEN-LRU has been available for several years now, and many vendors are 
already using it, so adding tracepoints is a necessary step.

>> Assisted-by: Claude:claude-opus-4-8
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   include/trace/events/vmscan.h | 47 +++++++++++++++++++++++++++++++++++
>>   mm/vmscan.c                   |  9 ++++++-
>>   2 files changed, 55 insertions(+), 1 deletion(-)
>>
> [...]
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 8409ea4bbf37..771fe6827939 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
> [...]
>> @@ -4876,6 +4877,12 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>>                  goto retry;
>>          }
>>
>> +done:
>> +       trace_mm_mglru_isolate_folios(mem_cgroup_id(lruvec_memcg(lruvec)),
>> +                                     type, swappiness, total_scanned, *isolated,
>> +                                     lrugen->min_seq[LRU_GEN_ANON],
>> +                                     lrugen->min_seq[LRU_GEN_FILE],
>> +                                     lrugen->max_seq);
> 
> Maybe `scan_folios()` would be a better place for this, as it can more
> directly reflect what we're doing for each type.
> 

scan_folios() already contains the trace_mm_vmscan_lru_isolate 
tracepoint(traditional tracepoint), but it lacks any GEN-LRU-specific 
information. Adding another tracepoint there would be redundant. Therefore, I 
placed the new tracepoint in isolate_folios(), where it can capture GEN-LRU's 
specific details. Additionally, it can indicate whether a fallback to the other 
type has occurred.

> 
>>          return total_scanned;
>>   }
>>
> 
> Best Regards
> Barry

-- 
Best regards
Ridong


