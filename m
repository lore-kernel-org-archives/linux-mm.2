Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 299E8F46C74
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 19:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E6AE6B0005; Mon,  6 Apr 2026 15:08:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BEA06B0088; Mon,  6 Apr 2026 15:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F16786B0089; Mon,  6 Apr 2026 15:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E20496B0005
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 15:08:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B10DA1605BE
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 19:08:20 +0000 (UTC)
X-FDA: 84629066760.20.C813D76
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf26.hostedemail.com (Postfix) with ESMTP id B0A0D14000A
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 19:08:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wunMr7fL;
	spf=pass (imf26.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775502499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UFapA+/+f9Y8DbS4JFAzR2c+AXc075dwW6fUywslDic=;
	b=lWzSkG+Zbl6/eMfYpq8MLn5kznBsoIOUNuGTnAS44koGUxvk8KZetxe5u31lKOxChS/9sI
	nbvMrCzU+ylGEXV8/p9GL1QwllVqTliPI9nipda8BR5OWurFCRVIzUn3zhj+fm8QbSbtKb
	r7AGtD9Rn0a7DNfuyEKaO5ZIMpvFC0Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wunMr7fL;
	spf=pass (imf26.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775502499; a=rsa-sha256;
	cv=none;
	b=uyBhlBLlNPASe5hbz4VIRx4qUp0KqsSDvkDWhF414CR2juzFQa9kNq78OGjT8JqCFT8yw4
	u8iIIb0k0zt1LxgXP6FggKlBE1Z6nWPjv4s3a0BFAMs9J5BaUOeqeIk1go9p6c50o7CbFl
	Ud4UWxJQRFb82PuBiM0LqNgv0+44fTw=
Message-ID: <6a41259c-bf69-49d5-9cba-80a5feb8ee8a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775502496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UFapA+/+f9Y8DbS4JFAzR2c+AXc075dwW6fUywslDic=;
	b=wunMr7fLL/+q3D6zujH47arhZ40hzscKc6Aq6mymRAr+Z1NJEN8M+H0Bwtgjg0bY1XfBCR
	PU48LBBhPkyHoYVFAaOYuP5cvKma0xtO5ecSzzC5wv8xLRYmON7MzZjJwZcqxoQy9yVlnQ
	CkE0BmEC1SWLn1iLWMkvkrviHQB1K1c=
Date: Mon, 6 Apr 2026 12:07:57 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v3] mm/vmpressure: skip socket pressure for costly order
 reclaim
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, willy@infradead.org, hannes@cmpxchg.org,
 david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, riel@surriel.com, kuba@kernel.org, edumazet@google.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260406174425.61692-1-jp.kobryn@linux.dev>
 <20260406105417.28fda9587146a011af2fb876@linux-foundation.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
In-Reply-To: <20260406105417.28fda9587146a011af2fb876@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: zdes1f1irbb3i1m53fcpb1jtxp5i3k4u
X-Rspamd-Queue-Id: B0A0D14000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1775502498-223141
X-HE-Meta: U2FsdGVkX18y+LZwL/B2zYyag2HEifPG6qB1hE/J+hEo1YsKHqFDlyffq47dT3ojPlEAHm6cQHzOeE3g/qVJwkZ91My8DQ1YKnnSXznYoHRti7z9g58aGjObfQ2P7SwHlmaq054mf1L0YFzkg5R6m9ohPAJTJp8cBMRWZLBdtoOrw+DbmstjS5+s9Y+v8stZqiVHaOrWwaI+sqnkBUSSJJG1AY2GmsU/mnxFipAt3wJWdaA3J/PBzZ1MKZ3oP4RbZEdhsaBBlltZwKnOL4BJ7bWmrzkIslXEVudBETKn8qcDbV6wVGRgnwm0xNZP4vI24Nx793yFpTnJvrNzfzmXwSt3hudZGaRuGl6SpCHsEFlIZtWgcGwq3TqRJu9no5wvYYC1UqUVnpaA4wRvlMHPS1vJbYxZosm/bRwwpyyj0sGUcNHF8rALh3hZejJVD3rH69G2v7tDenCQPg9cPdBD1YXc62MoPXD1k9ukQuH7mRO83+HHYIZQG0F1WR8sz+qZSyom+8STAEyMIDqDNufeUxSYtMvGgnqcL3t7vSBLSs7wmKv0fj4cfpXnwpoU38W39/eHgm32IjnCw2qBEwFIi+rRLZi8ddpCHecybTfrPhF6SwYEpXaeAb1qySrpRUpwC10QJk9L5UaVSoOLKqi555wwtxHl1Gmna/sBQWtHXKY56IXWAHFlEEUY4uA00I77Wa62dT57nmLTWu0KTzrd7k2ExypiOtWbzD8L9beB9p/z6mQzrJf10CjXMvmR32x+RZ4QDWjTPoyX56lb2Rll9elBOn5jTk9WmOCtwg7JTB2kSRAU3TcEke9ptA/Vw16ze4VEGOG/6Xy1OLLM7XSmjdai39iNxckDGJ45xmhjvhS9lmOBXIlfKMn/ckZkmwQ0h2mc+3oNxgG/PeCx81HpfSrkBvxl3fXF/ckKiigHdQDiBOsKaeOeFqFTmCT3icA3rTc1XF1qDIpLeOZgdOe
 Ddk+aqic
 qgcVyR2lkx5qruXriZyGpTX+lZXTgCD8ZpTPiYpPE+iJIqHO3n6U7/3sGCos50JVXw0QabofDN7iC9bhmNcdpDJ4QaHBYkejrDvcyQju9LcthfKthMngi6hnksp3EHBuhGqd2NEZNCuUwSOPRDGCP9FyZFfZsdyQiHc7u+MiJMpnBQ/zqRdBIzNl+X1g6vnX4G4eEbTEb/XEpV6s49Vk1qZ5Jtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/6/26 10:54 AM, Andrew Morton wrote:
> On Mon,  6 Apr 2026 10:44:25 -0700 "JP Kobryn (Meta)" <jp.kobryn@linux.dev> wrote:
> 
>> When reclaim is triggered by high order allocations on a fragmented system,
>> vmpressure() can report poor reclaim efficiency even though the system has
>> plenty of free memory. This is because many pages are scanned, but few are
>> found to actually reclaim - the pages are actively in use and don't need to
>> be freed. The resulting scan:reclaim ratio causes vmpressure() to assert
>> socket pressure, throttling TCP throughput unnecessarily.
>>
>> Costly order allocations (above PAGE_ALLOC_COSTLY_ORDER) rely heavily on
>> compaction to succeed, so poor reclaim efficiency at these orders does not
>> necessarily indicate memory pressure. The kernel already treats this order
>> as the boundary where reclaim is no longer expected to succeed and
>> compaction may take over.
>>
>> Make vmpressure() order-aware through an additional parameter sourced from
>> scan_control at existing call sites. Socket pressure is now only asserted
>> when order <= PAGE_ALLOC_COSTLY_ORDER.
>>
>> Memcg reclaim is unaffected since try_to_free_mem_cgroup_pages() always
>> uses order 0, which passes the filter unconditionally. Similarly,
>> vmpressure_prio() now passes order 0 internally when calling vmpressure(),
>> ensuring critical pressure from low reclaim priority is not suppressed by
>> the order filter.
> 
> Thanks.  I'd prefer to park this until after next -rc1.  I could be
> argued with, but....
> 
> What I'm not understanding from the above is how beneficial this patch
> is.  Some description of observed before-and-after behavior, preferably
> with impressive measurements?

Let me know if this data helps, and if you'd like this added to the
changelog.

On one affected host with impacted net throughput, the memory state at
the time showed ~15GB available, zero cgroup pressure, and the following
buddyinfo state:

Order FreePages
0:    133,970
1:    29,230
2:    17,351
3:    18,984
7+:   0

Using bpf, it was found that 94% of vmpressure calls on this host were
from order-7 kswapd reclaim.

TCP minimum recv window is rcv_ssthresh:19712.

Before patch:
723 out of 3,843 (19%) TCP connections stuck at minimum recv window

After live-patching and ~30min elapsed:
0 out of 3,470 TCP connections stuck at minimum recv window

