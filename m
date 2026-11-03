Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A130606A327
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 12:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dbTCJdF2
Received: by kanga.kvack.org (Postfix)
	id 577D36B05B3; Tue,  3 Nov 2026 07:24:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528776B05B4; Tue,  3 Nov 2026 07:24:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4176D6B05B5; Tue,  3 Nov 2026 07:24:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1774B6B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:24:00 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9D4A31403A8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:23:59 +0000 (UTC)
X-FDA: 85393724598.12.C332DEA
Received: from mta1.migadu.com (out-199.mta1.migadu.com [95.215.58.199])
	by imf12.hostedemail.com (Postfix) with ESMTP id C375840002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:23:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dbTCJdF2;
	spf=pass (imf12.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.199 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793708637;
	b=l+bx8NGKJxsveBl+dyrycggH8ApI5cmwealB3/XlMHWVLRLKqiC1NloCu+8v5HD4Y4KiXi
	Q45vdq5B1R8R4LswOwOSBW18/n5a/ptMgwhaI0xF5DaCsJTqDDx9aTWAHTWZlp79jy+HMD
	aMxYOMuZ+XQuwvrknV/6/s7bEhGXl/U=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dbTCJdF2;
	spf=pass (imf12.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.199 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793708637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5+giExnZG9PbIRprmj3rcwLAC4uTyxxBQab4OXS7D6o=;
	b=iUDnmzrWuRJ3IXVHaVcu8eo5LvhqbcbNl9PaFgpe+J9l3gbllVRPmt9mN2wOWnupyvCpVj
	6CFhf1U0YuOGlr8gz9lnOIw4SZRI0Pc5IXB8q/IEGUV/x7b7jzI7nCVW+7CjJlBWnZOxCa
	2MHN11hmTEghwD012Q5BWXR7sV3UGW4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZCZPLAdU2GP8PtTvn35MB7p7rMmvQ15GA72KpLOK3eo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793708632; v=1; x=1794313432;
 b=dbTCJdF2uGcqzh37oFPtMCzkhAalFFRRJDdXJ3PFE5wouyD0ejuykduxUhTOFCxnMbQqANKp
 nlP4F/PNQVafFAM1T3CV9vFtgoIYVeJCBEZZiwrQe0Xfppf5goqSZKwXRYoVzz477MXUSzNJH49
 rlmPhYYvxKH+9ZumpGmTeFfs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e671a108ae62cf5d;
	Tue, 03 Nov 2026 12:23:52 +0000
X-Mizu-Trace-ID: e671a108ae62cf5d
X-Migadu-Flow: FLOW_OUT
Message-ID: <f5137dbb-b0ed-44ea-a23f-5c848315a68a@linux.dev>
Date: Tue, 3 Nov 2026 20:23:37 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 7/7] mm/mglru: add tracepoint for inc_max_seq()
To: Barry Song <baohua@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 "open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261103025610.3738894-1-ridong.chen@linux.dev>
 <20261103025610.3738894-8-ridong.chen@linux.dev>
 <CAGsJ_4xCTSctcPcC7X6Dx4zYaOycaPqs0DG7AaxB55wx1Afwpg@mail.gmail.com>
 <9cabcddf-d807-4a36-84f1-5bb06ea72aac@linux.dev>
 <CAGsJ_4xXDZjhN+NkvtN+vAp8Bokack_JdNgP=nGPQtHUX8_rqg@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4xXDZjhN+NkvtN+vAp8Bokack_JdNgP=nGPQtHUX8_rqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mfusouk5pfcx3np8koxkuqado3jrxq4t
X-Rspamd-Queue-Id: C375840002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793708635-691063
X-HE-Meta: U2FsdGVkX1+gwL4uKFLMdKAFp0s3gb1HPGDi804aimKJohEUryZ8Ck1p7pscEZahS+PASaNReyQJTWbOpY2TxK74ykt+Pr1weNil/KAzfObDpvZALm10ngGLiYG26I4KjsWmOcHbcipYJQn9JcluMhSiHlMgaLHr8ZHqpRzmp+HO1pbdTMBhKwrKSENTdjs9+uKb+3SDipXSmmDtR1u9GLDIEiyyI8ggTQ4RJ3r2OkkW68f5+UACVfUDKmQ6wx2XdJIny5BzXI1uNHskE2KAYXoCpy1HfJU4oWwv5QWhp9SKRGQ5IA23HiCh6xs6vYQ5HcwK9UX5X56vqq77sZwpq4/a4DCihSbxN+TiRDA1iobTYKwOro+jjqUxg6Xf2+l2QQ3Jr1+DzrkT8b6S/rc7cpM9yObjbnUEqnHYrxZ7NjO42EHRAUQbvHwdbkHsW2e9ecPdqjK8nKRmfvSU6WN2snG24ChUkXGBQTY8d8joxGcyNEqF+UIwB51PVFSEt/Op/6CTBIdiGYCEBnBUtz9DlC9h5NVfzKshyINIqfaed7WdjbsqUMuQDkqq/j8V3/k5uQ2xjBid/wR+eyFKmksg9SP3SnVlZKmT+4ZPriMo+Fgcnz6lewcliexXfnog12cbOrl4qR0R1saRaX+pKeyCHYxclmK9a9e9HjjgNFw+1iH0bhkEplmBVxIErPTxK8kjXLOYq4/bH2Hqx/3vrI0Sjp126OH0BawyFmipqwPn2N2vedVWdtVWWBLtJr1Ez9kuQjTF7zbDoSQx3/EplnWhaXWByac6Re1HNXAx0kXnqlH1focd8P/PiskDq2AcoyMGPnuvL2TNptpBo0dFcTFCLlwWvzb3g8gaCXBZptbjQ4hRqeUjBoacgxCRhupM6Gzkq4S9rMo+vmdsmY+uJlmHtJxhvfdvsFS9cIss77BZphU/Fsyfz7NcIzQpW6wtZ+FbXrVMHGsJ2x7qbByPuAD
 S35+14i7
 ePJSA/Dimidurar4seE+luoLjiAmbOoE+hdsA9ajaTI+8xwW4ink2/ZtGTnNNPUxwUQ3t5NOtupjhQ/CGn8PbFI+bWF2KhKJKMjf0eZ8yQpWsQuO2NZshN8cXcvPFSvww0Mcg98k/IduSr0XY6/zs/DS6YMStXEiSX9P4NusqrFID+ILJqzcFclhCK9QQNcfhtUdveMptckeZnqFrdZ+YJ7tNdV4HQ6iBetROtPXAzfWmAHDF+gOR8hmA75WLQ0T2gthp3H9TlTsflysQT1uLBSGOlSDQgNZOZHKGRD7OrmA179aF04PpwJntCHpYf9cf6Cr6/qM4xC6WVNE4BZZ6wyZ1U5n2CVwMZK/F441wwFAZrzeDSj9o8wG10Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/3/2026 6:00 PM, Barry Song wrote:
> On Tue, Nov 3, 2026 at 4:39 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>>
>>
>> On 11/3/2026 2:48 PM, Barry Song wrote:
>>> On Tue, Nov 3, 2026 at 10:58 AM Ridong Chen <ridong.chen@linux.dev> wrote:
>>>>
>>>> From: Ridong Chen <chenridong@xiaomi.com>
>>>>
>>>> Aging in MGLRU advances max_seq via inc_max_seq(), creating a new
>>>> youngest generation. There is currently no tracepoint on this path, so
>>>> the moment a new generation is created, and how the min_seq of each type
>>>> trails behind it, cannot be observed as it happens.
>>>
>>> We might be more interested in why aging is triggered rather
>>> than the exact moment when max_seq is advanced.
>>>
>>> With your patch, we get:
>>>
>>> ~ # cat /sys/kernel/tracing/trace | grep mglru_inc_max_seq
>>>              a.out-93      [001] d..1.   278.276539:
>>> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=4 anon_min_seq=2
>>> file_min_seq=1 nr_anon={0x0,0xf016,0x12,0x0}
>>> nr_file={0x1886,0xb,0x4c,0x0}
>>>            kswapd0-50      [000] d..1.   278.422400:
>>> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=5 anon_min_seq=2
>>> file_min_seq=2 nr_anon={0x5,0xccb6,0x3439,0x0}
>>> nr_file={0x4ae,0x4f,0x55,0x0}
>>>            kswapd0-50      [000] d..1.   278.508003:
>>> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=6 anon_min_seq=3
>>> file_min_seq=4 nr_anon={0xccb6,0x3d29,0x1,0x0}
>>> nr_file={0x0,0x59,0x7,0x0}
>>>            kswapd0-50      [000] d..1.   280.046056:
>>> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=7 anon_min_seq=4
>>> file_min_seq=5 nr_anon={0x3bf3,0xcbbd,0x23e,0x0}
>>> nr_file={0x0,0xb,0x1,0x0}
>>>            kswapd0-50      [000] d..1.   280.124876:
>>> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=8 anon_min_seq=5
>>> file_min_seq=6 nr_anon={0xcafd,0x3e31,0x0,0x0}
>>> nr_file={0x0,0x5,0x7,0x0}
>>>              a.out-96      [001] d..1.   290.629014:
>>> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=9 anon_min_seq=7
>>> file_min_seq=6 nr_anon={0x0,0x10615,0xb,0x0}
>>> nr_file={0x331,0xb,0x9a,0x0}
>>>            kswapd0-50      [000] d..1.   290.653098:
>>> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=10 anon_min_seq=7
>>> file_min_seq=7 nr_anon={0x15,0xef23,0x18c4,0x0}
>>> nr_file={0xb,0xb8,0x55,0x0}
>>>              a.out-96      [001] d..1.   290.684875:
>>> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=11 anon_min_seq=8
>>> file_min_seq=9 nr_anon={0xeee3,0x1afb,0x2,0x0}
>>> nr_file={0x0,0x76,0x4,0x0}
>>>
>>> You can see that the youngest generation is always zero,
>>> because you're just getting the newly added youngest
>>> generation :-)
>>>
>>
>> Hi Barry,
>>
>> Thank you very much for testing and reviewing.
>>
>>> This somehow suggests that the information is redundant, as
>>> there is always a zero there.
>>>
>>> I suspect we'll need an additional tracepoint to show why
>>> aging is triggered and at what sc->priority it happens.
>>>
>>> But do you know why you trace the moment just after aging
>>> is completed, rather than the reason why aging is needed?
>>>
>> My original goal was to pair it with mm_mglru_scan_folios, to see how
>> the aging window of each memcg moves. The per-generation anon/file
>> nr_pages were added following your suggestion on v1. I put it at the
>> end of inc_max_seq() because of the restart there, as max_seq and
>> min_seq are only final after that.
> 
> The per-generation anon/file nr_pages are perfectly good, as
> they can also help explain why aging is needed, especially
> now that we're introducing new code for imbalance-based
> aging.
> 
>>
>> You make a very good point that the reason for aging is also
>> important. So I'd like to discuss which way is better:
>>
>> 1) Keep mm_mglru_inc_max_seq, and add another tracepoint at the aging
>>    decision in try_to_shrink_lruvec(), reporting why aging is needed
>>    and at what sc->priority.
>>
>> 2) Replace mm_mglru_inc_max_seq with a single tracepoint in
>>    try_to_shrink_lruvec(), right before try_to_inc_max_seq(), reporting
>>    the reason, sc->priority, swappiness, max_seq/min_seq and the
>>    per-generation nr_pages before aging. The youngest generation is
>>    not empty at that point, and the new window after aging can still
>>    be seen from the following mm_mglru_scan_folios.
>>
>> Which one do you prefer?
> 
> Maybe we should keep option 2 for now. Understanding why
> we are aging and at what priority is much more important,
> especially since we're still introducing some
> imbalance-based aging code.
> 
> It should be quite simple, just a matter of moving the code
> around a little.
> 
> If we later find a good reason to have option 1, we can
> always add it, right?
> 

Hi Barry,

Agreed, I'll go with option 2. Two things I'd like to confirm first:

1) To report the reason, should_run_aging() would need to return it
  instead of a bool, e.g. an enum like:

   enum lru_gen_aging_reason {
	AGING_NONE,
	AGING_NO_EVICTABLE,     /* eviction is not possible anymore */
	AGING_MIN_GENS,		/* better to age, eviction still possible */
   };
	
Or just report sc->priority, swappiness, max_seq/min_seq and the
per-generation nr_pages, and let users derive the reason from them?
The former is more direct, the latter keeps should_run_aging()
unchanged.

2) try_to_shrink_lruvec() has changed quite a lot recently, e.g.
Kairui's reclaim loop rework, and your swappiness series also touches it, 
including the aging part. Is it stable enough now to carry a tracepoint there?

-- 
Best regards
Ridong


