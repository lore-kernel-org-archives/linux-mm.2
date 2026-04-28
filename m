Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FC9EFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 16:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 523306B0005; Tue, 28 Apr 2026 12:36:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA566B008A; Tue, 28 Apr 2026 12:36:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410646B008C; Tue, 28 Apr 2026 12:36:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DEBE6B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:36:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96CA3160321
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:36:26 +0000 (UTC)
X-FDA: 84708517572.26.9C7BBF8
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id BC15B140002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:36:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bW9BrJEf;
	spf=pass (imf23.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777394185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Cr9IdcujjQrXcfxbwzSQNhzqsNG4ekgaxSa1GmQWbM=;
	b=Hg4YtriLVPbI/u8ck2CahisSIIpl4ZV2UIS0hJULKCgUDCs8nLj5lG8U48USFLHBZ4T58n
	9V+/CWVieDarBVXOKlbr9xagWx5rEOK46lzl+4xTTHC7IVoatHoxS+lvMroLZj6GjXF2ap
	H6ucFZQrPjayRa04wi+ZFdFCi0jfhnI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bW9BrJEf;
	spf=pass (imf23.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777394185; a=rsa-sha256;
	cv=none;
	b=arKUUaDPpCMV5lXamgktkQ9MUSfcXPhbq8gJXofIG1rZHqzqlwyvO44ErI9ORas7wbKgH3
	39qLOKr+wkkfuULr9y/UMGJQGLe+hlcyOb7lkg8hYV+oXvXLUwIU61dEpEMzIFQJ+QKcDG
	emSmI4RIXkQNH3pFERsuSyAPn0e9joU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777394181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Cr9IdcujjQrXcfxbwzSQNhzqsNG4ekgaxSa1GmQWbM=;
	b=bW9BrJEfiNRXw9wVleUkOQUycSgOVtGPI58dwQeqXqBz41YpAbRZ4sg8VMDlKaibWw0IBV
	eJqFVMBloqZSmmiBwGcEMnQJJR5hLLG8y3JMYYiTH8H5kZVglYUQc+ggiR6rphQ74R2LD9
	R9rEpP4qIplSronShsTcXldtmkNZjGU=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: bpf <bpf@vger.kernel.org>,  linux-mm <linux-mm@kvack.org>,  Vlastimil
 Babka <vbabka@kernel.org>,  Shakeel Butt <shakeel.butt@linux.dev>,  Andrew
 Morton <akpm@linux-foundation.org>,  lsf-pc
 <lsf-pc@lists.linux-foundation.org>,  Daniel Borkmann
 <daniel@iogearbox.net>
Subject: Re: [LSF/MM/BPF TOPIC] Using BPF in MM
In-Reply-To: <014f3c0a-7c6f-4f64-95cd-b7b69d804880@kernel.org> (David
	Hildenbrand's message of "Tue, 28 Apr 2026 10:12:16 +0200")
References: <7ia4o6j4c5y1.fsf@castle.c.googlers.com>
	<014f3c0a-7c6f-4f64-95cd-b7b69d804880@kernel.org>
Date: Tue, 28 Apr 2026 16:35:52 +0000
Message-ID: <7ia4h5ov6o0n.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: hu5szdo1wdsm6eeedrgpb8hb8s3mbh1s
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BC15B140002
X-Rspam-User: 
X-HE-Tag: 1777394184-714259
X-HE-Meta: U2FsdGVkX19gHEESgqtC2mpUZnceWWslI287FXnzLZxy31kp6x3+ijgXpKamU/JvNPYieyb45LQdzqvRrTYnuT9pHYhiU5P35VUqtR7UZJaTMyBM6p9+nI1nOwsX0NGiN6QbGCtvRYJ8pAI1pRNrNcElHXW6jSTd9wBbuEDdebVWakseSHan4v6GkJTPmtG3etEICpZBn8RKF+NkyRTY/ya5XClc3JvJs4vjNma+4x6elCpFo6XRLhvRY5DpY510QIDQam8/bFF3iPbV8jRPMBn6LdEhGJRDghZYTy7zxMtB2XwlN+RF17gQpruYF1i/qtmIjs1BafZG6ntwI0C+gDY8d8MZ/ij0tJamZsiuE6d6l/NSzVubcRuwswbp7hy6pSYA6TXIJz8VxxQTM3+69LVfKm16IDV2Gu4mZt9Y+sRnHZdNCmyETbmBXVDU4HqeoPeebxGHn8R1JEDgqUsKBoxsrZ66Wd5b4gB8orrJVsrFgO9kCDIBBYL1bfUfgv11q356r5Zw43zyw22tudQvpxhDMlf3nQXqEc1Sut2lPliLvXSjbaNa4FIcjaaQY7SECzp23gIIt0mNgQyjc4rl4WSLF/gle2I5D1o27Q0R5IBOrWchdDNRfjKiSwtQdOgJCyyXEgCzCMRX7kNacOZbgUeaxX54eGaSu/ym52LONf7Lck3zPraLZlLAAWYC2lcPs7POJLmxv6I4cpgu/4W60E3FsooMEuNYX+eAz5LiOWjFjqT/wnwczJ7AAcXX80PPXzdeRVTBWTQpa3atvgvGY0Alw+7l2+7r9aLkfZXavGivz+r2iy5PbdajBFY1gxLlfdYbpU+wRs5l2tGO6kDpAujI3oznDj0kLkkvwg9s+zGi5idkqCdkbi4ObaWAShRVv571QvjbAk4y8bfWL3oImbiBSAGDfuI5+fC6zDO35pXmfQjhKeDxCTzSkM49d26OXSEypLpHh9SRJcpBXzo
 4m/oZjpY
 MrU3h9fPtRFbM+Usl6LcGrr/pPkDKFG3eymbWBn0bk0WNV2LLz2Zdm0AtMU3/3gn00qp2PA5601lrWE9tPjRHsnEpj3mAo2UBloOPveaeyLQa7J8wQjSNW9tTYW02K2SvCdDCwErbjCmtgmuyf8itV31sEnAyjkm1B+Et
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 4/28/26 01:57, Roman Gushchin wrote:
>> [LSF/MM/BPF TOPIC] Using BPF in MM
>> ----------------------------------
>> 
>> Over the last decade, BPF successfully penetrated into multiple kernel
>> subsystems: started as a feature to filter (out) networking packets,
>> it captured its place in networking, tracing, security, HID drivers,
>> and scheduling. Memory management is a logical next step, and recently
>> we saw a growing number of proposals in this area.
>> 
>> In (approximately) historical order:
>>   - BPF OOM
>>   - BPF-based memcg stats access (landed)
>>   - BPF-based NUMA balancing
>>   - eBPF-mm
>>   - cache_ext (BPF Page Cache)
>>   - memcg_ext
>
> There was also the BPF THP control.

Thanks, missed that.

>
>> 
>> There are some obvious target which haven't been covered yet:
>>   - BPF-driven readahead control
>>   - BPF-driven KSM
>>   - BPF-driven guest memory control
>> 
>> Despite a large number of suggestions only a relatively small feature
>> (query memcg statistics from BPF) made it to upstream.
>> 
>> It looks like using BPF in the MM subsystem comes with a set of somewhat
>> unique challenges and questions to be answered.
>
> [...]
>
> I think you are missing one of the most important points: Unclear ABI stability
> guarantees.

Totally agree, it's just not specific to mm and is not very new.
Arguments about the ABI stability are almost as old as BPF itself, e.g.
a quick search gave me a lwn article from 2019:
https://lwn.net/Articles/787856/ .

>
> One the one hand, we are told that there are no ABI stability guarantees, and
> that we can change hooks (add/remove/modify) any time we want.
>
> On the other hand, as soon as there is some ebpf program out there that we
> break, you can rest assured that there will be trouble.
>
> In the area of THP, where we don't even know which hooks we will need long term
> and how they would look like, that was one of the reasons why the BPF THP
> control was rejected.

Agree. And in my mind it's also related to safety/performance tradeoff:
if we use very generic hooks/interfaces, it's easier to keep them stable
and meaningful, but then it's hard to guarantee safety without
performance sacrifices. Or we use very targeted policy hooks, then it's
much easier to make them safe and performant, but they may become
obsolete very quickly.

