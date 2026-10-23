Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABD29606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 01:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=BiS6WUs6
Received: by kanga.kvack.org (Postfix)
	id 8A3296B0A97; Thu, 22 Oct 2026 21:36:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8550F6B0A98; Thu, 22 Oct 2026 21:36:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 768716B0A99; Thu, 22 Oct 2026 21:36:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4E75B6B0A97
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 21:36:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4D59EA030E
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 01:36:15 +0000 (UTC)
X-FDA: 85352175510.18.1A9242A
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4BFB8A0006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 01:36:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BiS6WUs6;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792719373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PY0NJAPke28sO3SvXiUYBiEZjRXhf6oHVUh0MyPbglg=;
	b=Y1EV0kDNxDVfm+VN4S6Wy7zedIRnU91m+cHRpzLYeeKvZszCznjTe6qlJBafm10IVBjhya
	9MJhb98dexkdVsJwD7O/qgQWUCsMCIqsF3DH4DKYKLY4mM4Jxm159/e0bIV6hW4W0YdYIc
	UtulgCAbWjrFRT0qxXgN+xexyD8/5x4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BiS6WUs6;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792719373;
	b=nGx+Rs0R1yeHHUAlN35+PEXV0AcrNdFVD1CVE3UieasOS238KsmRz9i+f0WJC4ZX3a7Abl
	CM6h/bLg28SqZHiladUcBu0NbHH/BvPCUyprizh8BaJxS4dh4HrR/H77F7Ce0BYSICi+6l
	GxhQuHCvSjZq+xssI/5DzchZtMEqLkc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792719369; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=PY0NJAPke28sO3SvXiUYBiEZjRXhf6oHVUh0MyPbglg=;
	b=BiS6WUs6t4MKba0QHlPys0sPpMxAwV/k+pQ9CgDOoNCZJRBrP+G5d2bJm8vwKzCwrKM/H3B7/lMmN8yeNeMfWgOClTMukDgSbIYy+Sv3QeiXUk1FrUI13QYWs+0m827pvaRvPO6xO9ppobtthheG22j6UfCm1HmqTxoeCLB7MtY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0XDKY5aF_1792719366;
Received: from 30.74.144.154(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDKY5aF_1792719366 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Oct 2026 09:36:06 +0800
Message-ID: <4e647816-0b8b-4a75-8777-8580a574d752@linux.alibaba.com>
Date: Fri, 23 Oct 2026 09:36:05 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2] mm: vmscan: avoid anon scanning for GFP_NOIO with
 low swapcache in MGLRU
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com,
 baoquan.he@linux.dev, david@kernel.org, hannes@cmpxchg.org,
 kasong@tencent.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 liuxiang.277@bytedance.com, ljs@kernel.org, mhocko@kernel.org,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, weixugc@google.com,
 yuanchu@google.com, zhangbo56@xiaomi.com
References: <0cbd219d-f69d-4f72-aec5-43e1f2d978de@linux.alibaba.com>
 <20261022102726.56682-1-baohua@kernel.org>
 <fc302ca3-6bf6-4bde-b3e8-8d2e93a4e4ac@linux.alibaba.com>
 <CAGsJ_4z9GZkpV+mpoGogma4oSX4cHy+2UDzyUQSjjOLOfekEPg@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4z9GZkpV+mpoGogma4oSX4cHy+2UDzyUQSjjOLOfekEPg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4BFB8A0006
X-Stat-Signature: odbajbq6ft7rspii1w5arxjwrwrmuj8b
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792719371-533889
X-HE-Meta: U2FsdGVkX1/dB/5ifLN5ZCz/eCxO8R0ZYFy9BH87xJmTZO+FWxO1zwwgSg5vU16goyNzEHEyGzPXVc1jTQd5C8Tn2XuMSm8HBVrjWKcLG8cUJa4fLtXYfwpCBcdoUbXIKFqw/QFEXB/TDxXbpExEN0gC4oe9we1nQnWgIjWpjCCAZpWzHtruPax4zPYZ9IcGEHImFL6uyyxv76y6L2ZyNwuUhse8+OkGvpWO08OEFPEk2P57YYx+UTOVYGcz5svyYy6Z234+gCzwdtrsqIo469u1Qxn0iAG3vzl+64TS24hf3W+DMI35Kt+TWv5ezPnDUrRR2ZVHxH+6NQ9bMkZOXmBapd+B8NVYEnCFafHyRHsL6JCC7N+VZ+g1Sx9KeYuGrSmxVNTAqznz7lmIf1wA1uzjRKf+ZDMIV8TQhIRM6pZFhOR8qE6pHJnO+EAeiTvESRT7eh/K4FlgQPLvQfoU8hu8XBD7DPvnRQjM4jDxTl0nZcVWZj4iev6FRarlRvKnlUKN6bNJvOqPKYY3rAoeL/S1yhCaIkz+6RULVF70NT8LF9BRhUfl7tg/D6dD3OlhObTTyfsAU1VcUYaEff82QwafvSc/3vosr3+xMY9hq1p/iBSjMyW2w+Ua90cW49y6/3RTYL85x7kpoflTgAVQfe9ltQFdRd2gMbYcER/aG9YjoN8wDZul3FSWRvkwUlnhasyQjqiHDB1k2vhgyvb62xtFpJ93qWLi9RNphJajjZkIgMAy74+cA9cVkXOX4dcUvK5yBQuIJGNtsCv5ZwDHYSRJW7lK87kbPunI4oOp03WB71RYnHFB6lqiCrEzgDQ7O7XYUzmOlzWn6SSVFgo/LgnqJeYUkGbBTQmuVn6BpQXNWeoEkb8gs/6aXROgEG6AbnC8VL9RcvKcu26U/RhpNfAgbxxVbGh6Btf8jyY+J8vFPWKYktu7Q9qA+OxfMMe3BwQs0TQbpjn1wMuxHDH
 j4DThGMo
 cTsX5Rasad8GccGkxfE5RKyHKQhTzj1hO4fmaxQeYsfgZtY6Qith5dIuVFtABGVwQomQYs5hbp7mgZzq4WTkBjTWjJSGvfqTdxuj+HRi3DuPWVof7c9Y3CaRRYDnkdzB5mP3b4WFRUB5b14z9dq0JMANMVC7mnnTbFJ0Sktxx/KDUGSYbpd9VcPVMyQGHeDsbLBYsvuWtBZEHenBmohudZp8VxarEkNRn0hJmlu7BkTofAW66y50uYzdUFEesUE4e6bXrlwP9qdHFrBzGS6o7Mx8L9Yg4d2OkHi1520g/jL0jjKEMQIakPN1FMMUxbl83FTPaBephGoxzk+4trT+06cE0G+JiRbyhE7hYTBwx8wzq1MPitbwKSTPKGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/23/26 5:19 AM, Barry Song wrote:
> On Thu, Oct 22, 2026 at 7:26 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
> [...]
> 
>>>>                    }
>>>>
>>>>                    if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
>>>> -                       if (try_to_inc_max_seq(lruvec, max_seq,
>>>> swappiness, false))
>>>
>>> This is quite tricky. If we pass swappiness=0, anon aging will be
>>> skipped. Do we want that for GFP_NOIO cases? I mean, these are not
>>> real cases where anon aging should be disabled.
>>
>> No, we have real use cases where 'vm_swappiness' is set to 0, which
>> means the workload never reclaims anon folios. So in this case we don't
>> need to age anon folios.
> 
> My concern is that setting swappiness to 0 for GFP_NOIO also skips
> anon aging, making it behave the same as a real swappiness=0.

It will not. We will force anon aging for GFP_NOIO case.

> However, GFP_NOIO is only a temporary state, and subsequent
> allocations may not use GFP_NOIO.

